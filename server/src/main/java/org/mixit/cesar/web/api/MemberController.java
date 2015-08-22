package org.mixit.cesar.web.api;

import java.util.List;
import java.util.stream.Collectors;

import javax.websocket.server.PathParam;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.mixit.cesar.dto.MemberResource;
import org.mixit.cesar.model.member.Member;
import org.mixit.cesar.repository.MemberRepository;
import org.mixit.cesar.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Api(value ="Conference members",
        description = "Member Api helps you to find all the persons linked with the conference. Members have an account " +
                "on our website, participants have a ticket for the conference. You can also find informations about the " +
                "speakers, the staff and the sponsors")
@RestController
@RequestMapping("/api/member")
public class MemberController {

    @Autowired
    MemberRepository memberRepository;

    @Autowired
    EventService eventService;

    private <T extends Member> ResponseEntity<List<MemberResource>> getAllMembers(List<T> members) {
        return new ResponseEntity<>(members
                .stream()
                .map(m -> MemberResource.convert(m))
                .collect(Collectors.toList()), HttpStatus.OK);
    }

    @RequestMapping("/{id}")
    @ApiOperation(value="Finds one member", httpMethod = "GET")
    public ResponseEntity<MemberResource> getMember(@PathVariable("id") Long id) {
        return new ResponseEntity<>(MemberResource.convert(memberRepository.findOne(id)), HttpStatus.OK);
    }

    @RequestMapping
    @ApiOperation(value="Finds all members", httpMethod = "GET")
    public ResponseEntity<List<MemberResource>> getAllMembers() {
        return getAllMembers(memberRepository.findAllMembers());
    }

    @RequestMapping(value = "/staff")
    @ApiOperation(value="Finds Mix-IT staff", httpMethod = "GET")
    public ResponseEntity<List<MemberResource>> getAllStaffs() {
        return getAllMembers(memberRepository.findAllStaffs());
    }

    @RequestMapping(value = "/participant")
    @ApiOperation(value="Finds all participants", httpMethod = "GET")
    public ResponseEntity<List<MemberResource>> getAllParticipants(@RequestParam(required = false) Integer year) {
        return getAllMembers(memberRepository.findAllParticipants(eventService.getEvent(year).getId()));
    }

    @RequestMapping(value = "/speaker")
    @ApiOperation(value="Finds all speakers", httpMethod = "GET")
    public ResponseEntity<List<MemberResource>> getAllSpeakers(@RequestParam(required = false) Integer year) {
        return getAllMembers(memberRepository.findAllSpeakers(eventService.getEvent(year).getId()));
    }

    @RequestMapping(value = "/sponsor")
    @ApiOperation(value="Finds all sponsors", httpMethod = "GET")
    public ResponseEntity<List<MemberResource>> getAllSponsors(@RequestParam(required = false) Integer year) {
        return getAllMembers(memberRepository.findAllSponsors(eventService.getEvent(year).getId()));
    }

}