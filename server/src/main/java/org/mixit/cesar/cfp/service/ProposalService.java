package org.mixit.cesar.cfp.service;

import static org.mixit.cesar.cfp.model.ProposalError.Code.REQUIRED;
import static org.mixit.cesar.cfp.model.ProposalError.Entity.PROPOSAL;
import static org.mixit.cesar.cfp.model.ProposalStatus.CREATED;
import static org.mixit.cesar.cfp.model.ProposalStatus.SUBMITTED;
import static org.mixit.cesar.cfp.model.ProposalStatus.VALID;
import static org.mixit.cesar.cfp.service.MailCfpBuilder.TypeMail.SESSION_SUBMITION;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import com.google.common.collect.Sets;
import org.mixit.cesar.cfp.model.Proposal;
import org.mixit.cesar.cfp.model.ProposalError;
import org.mixit.cesar.cfp.model.ProposalStatus;
import org.mixit.cesar.cfp.repository.ProposalRepository;
import org.mixit.cesar.security.model.Account;
import org.mixit.cesar.security.repository.AccountRepository;
import org.mixit.cesar.security.service.mail.MailerService;
import org.mixit.cesar.site.model.member.Interest;
import org.mixit.cesar.site.model.member.Member;
import org.mixit.cesar.site.repository.InterestRepository;
import org.mixit.cesar.site.repository.MemberRepository;
import org.mixit.cesar.site.service.EventService;
import org.mixit.cesar.site.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ProposalService {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private ProposalRepository proposalRepository;

    @Autowired
    private InterestRepository interestRepository;

    @Autowired
    private MailCfpBuilder mailBuilder;

    @Autowired
    private MailerService mailerService;

    /**
     * Check the required fields. A user can save a partial proposal and complete it later
     */
    public Set<ProposalError> check(Proposal proposal) {
        Set<ProposalError> errors = Sets.newHashSet();

        //A proposal is valid when speakers are valid
        proposal.getSpeakers().forEach(speaker -> errors.addAll(memberService.checkSpeakerData(memberRepository.findOne(speaker.getId()))));

        if (proposal.getFormat() == null) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("format"));
        }
        if (proposal.getSummary() == null) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("summary"));
        }
        if (proposal.getLevel() == null) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("level"));
        }
        if (proposal.getDescription() == null) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("description"));
        }
        if (proposal.getIdeaForNow() == null) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("ideaForNow"));
        }
        if (proposal.getLang() == null) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("lang"));
        }
        //To be valid the profile of the speakers have to be valid
        if (proposal.getSpeakers().isEmpty()) {
            errors.add(new ProposalError().setEntity(PROPOSAL).setCode(REQUIRED).setProperty("speaker"));
        }
        return errors;
    }

    public Proposal save(Proposal proposal, Account account) {
        Objects.requireNonNull(proposal, "proposal is required");
        boolean newProposal = false;

        Proposal proposalPersisted = proposal.getId() == null ? null : proposalRepository.findOne(proposal.getId());

        if (proposalPersisted == null) {
            newProposal = true;
            proposalPersisted = proposalRepository.save(proposal
                    .setAddedAt(LocalDateTime.now())
                    .setEvent(EventService.getCurrent())
                    .setGuest(false)
                    .setStatus(CREATED)
                    .addSpeaker(accountRepository.findOne(account.getId()).getMember())
                    .clearInterests());
        }
        else {
            proposalPersisted
                    .setCategory(proposal.getCategory())
                    .setDescription(proposal.getDescription())
                    .setFormat(proposal.getFormat())
                    .setTitle(proposal.getTitle())
                    .setSummary(proposal.getSummary())
                    .setLevel(proposal.getLevel())
                    .setCategory(proposal.getCategory())
                    .setFormat(proposal.getFormat())
                    .setIdeaForNow(proposal.getIdeaForNow())
                    .setMaxAttendees(proposal.getMaxAttendees())
                    .setTypeSession(proposal.getTypeSession())
                    .setMessageForStaff(proposal.getMessageForStaff())
                    .setMaxAttendees(proposal.getMaxAttendees())
                    .clearSpeakers()
                    .getSpeakers().addAll(proposal.getSpeakers());
        }

        //Interests
        updateProposalInterest(proposalPersisted, proposal);

        //Validity
        proposalPersisted.setValid(check(proposalPersisted).isEmpty());

        //The state can change only if session is not submitted
        if(proposal.getStatus()==null || VALID.equals(proposal.getStatus()) || CREATED.equals(proposal.getStatus())) {
            if (proposalPersisted.isValid()) {
                proposalPersisted.setStatus(VALID);
            }
            else {
                proposalPersisted.setStatus(CREATED);
            }
        }

        return proposalPersisted;
    }


    public ProposalStatus submit(Proposal proposal, Account account) {
        Proposal proposalPersisted = save(proposal, account);

        if (VALID.equals(proposalPersisted.getStatus())) {
            proposalPersisted.setStatus(SUBMITTED);

            proposalPersisted.getSpeakers()
                    .stream()
                    .forEach(speaker -> {
                                Member member = memberRepository.findOne(speaker.getId());
                                mailerService.send(
                                        member.getEmail(),
                                        mailBuilder.getTitle(SESSION_SUBMITION),
                                        mailBuilder.buildContent(SESSION_SUBMITION, account, proposal));
                            }
                    );
        }
        return proposalPersisted.getStatus();
    }

    /**
     * Helper to update the interest list
     */
    protected void updateProposalInterest(Proposal proposalDb, Proposal proposal) {
        //We can delete old references
        proposalDb.getInterests().removeAll(
                proposalDb.getInterests()
                        .stream()
                        .filter(inter -> !proposal.getInterests().stream().filter(i -> i.getName().equals(inter.getName())).findFirst().isPresent())
                        .collect(Collectors.toList())
        );

        proposal
                .getInterests()
                .stream()
                .forEach(inter -> {
                    Optional<Interest> interest = proposalDb.getInterests().stream().filter(i -> i.getName().equals(inter.getName())).findAny();
                    if (!interest.isPresent()) {
                        Interest interes = interestRepository.findByName(inter.getName());
                        if (interes == null) {
                            interes = interestRepository.save(new Interest().setName(inter.getName()));
                        }
                        proposalDb.addInterest(interes);
                    }
                });
    }

    public void delete(Long id){
        proposalRepository.delete(id);
    }
}
