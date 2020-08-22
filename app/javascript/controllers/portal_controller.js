import ApplicationController from './application_controller'

/* This is the custom StimulusReflex controller for PortalReflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  /* Reflex specific lifecycle methods.
   * Use methods similar to this example to handle lifecycle concerns for a specific Reflex method.
   * Using the lifecycle is optional, so feel free to delete these stubs if you don't need them.
   *
   * Example:
   *
   *   <a href="#" data-reflex="PortalReflex#example">Example</a>
   *
   * Arguments:
   *
   *   element - the element that triggered the reflex
   *             may be different than the Stimulus controller's this.element
   *
   *   reflex - the name of the reflex e.g. "PortalReflex#example"
   *
   *   error - error message from the server
   */

  static targets = [ "canvas" ];
  map;

  connect () {
    super.connect();
    if (this.canvasTargets.length !== 0) {
      this.showPortal()
    }
  }

  readSingleFile(e) {
    var file = document.getElementById("har-file").files[0];
    if (!file) {
      return;
    }
    var reader = new FileReader();
    reader.onload = function(e) {
      var contents = e.target.result;
      const regexp = /"{\\\"result\\\":{\\\"map\\\":.+}"/g;
      const info_regexp = /\[".\",\".\",(?<latitude>\d+),(?<longitude>\d+),(?:\d+,){3}\"(?<url>http:\/\/.{1,4}\.googleusercontent\.com\/.{60,120}?)\",\"(?<name>.+?)\",.+?,\d+\]/g;
      const array = _.uniq([...contents.matchAll(regexp)].map(x=>JSON.parse(x[0])).map(x=>[...x.matchAll(info_regexp)]).flat().map(x=>x.groups));

      console.log(array)
      fetch("/portals.json", {
        method: "POST",
        body: JSON.stringify({capture: array}),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
        },
        credentials: 'same-origin'
      }).then(res => {
        console.log("Request complete! response:", res);
        if (res.ok===true) {
          window.location.replace('/portals')
        }
      });
      // var element = document.getElementById('file-content');
      // element.textContent = array;
    };
    reader.readAsText(file);
  }

  showPortal () {
    const neutaral_icon = L.icon({iconUrl: '/neutral.png', iconAnchor: [25, 25], popupAnchor: [0, -6],})
    const coordinate = this.element.getAttribute("data-portal-coordinate").split(",").map(x=>parseFloat(x))
    const portal_name = this.element.getAttribute("data-portal-name")
    const portal_url = this.element.getAttribute("data-portal-url")
    this.map = L.map('canvas').setView(coordinate, 16);
    L.tileLayer.provider('CartoDB.DarkMatter').addTo(this.map);  // 'CartoDB.DarkMatter' 'CartoDB.Positron'
    let marker = L.marker(coordinate, {icon: neutaral_icon}).addTo(this.map);
    marker.bindPopup("<b class='font-bold text-2xl'>"+portal_name+"</b><br><img class='w-48 rounded' alt='"+portal_name+"' src='"+portal_url+"'/>", {maxWidth: 200, minWidth: 120}).openPopup();
  }
  // beforeUpdate(element, reflex) {
  //  element.innerText = 'Updating...'
  // }

  // updateSuccess(element, reflex) {
  //   element.innerText = 'Updated Successfully.'
  // }

  // updateError(element, reflex, error) {
  //   console.error('updateError', error);
  //   element.innerText = 'Update Failed!'
  // }
}
