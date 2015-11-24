(function () {

  'use strict';

  angular.module('cesar-menu').directive('cesarMenu', function () {
    return {
      templateUrl: 'js/menu/menu.directive.html',
      controller: 'cesarMenuCtrl',
      controllerAs: 'ctrl'
    };
  });
})();
