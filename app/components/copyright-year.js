import Component from '@ember/component';
import { getOwner } from '@ember/application';
import $ from 'jquery';


export default Component.extend({
  currentYear: (new Date()).getFullYear(),
  didInsertElement(){
    this._super(...arguments);
    let application = getOwner(this).application;
    $("#updated-on a").text(`Last updated on ${$.datepicker.formatDate("d MM yy", new Date(application.mapConfig.creation_time))}`);
  }
});
