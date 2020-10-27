import ApplicationController from "./application_controller";

/* This is the custom StimulusReflex controller for IfsSearchReflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  /* Reflex specific lifecycle methods.
   * Use methods similar to this example to handle lifecycle concerns for a specific Reflex method.
   * Using the lifecycle is optional, so feel free to delete these stubs if you don't need them.
   *
   * Example:
   *
   *   <a href="#" data-reflex="IfsSearchReflex#example">Example</a>
   *
   * Arguments:
   *
   *   element - the element that triggered the reflex
   *             may be different than the Stimulus controller's this.element
   *
   *   reflex - the name of the reflex e.g. "IfsSearchReflex#example"
   *
   *   error - error message from the server
   */

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
  static targets = ["column"];
  map;

  connect() {
    super.connect();
    this.showColumn(0);
  }

  currentColumn(element, reflex) {
    this.showColumn(parseInt(element.target.getAttribute("data-column-index")));
  }

  showColumn(index) {
    this.index = index;
    let coordinates = this.columnTargets[index].getAttribute(
      "data-coordinate-list"
    );
    this.columnTargets.forEach((el, i) => {
      el.classList.toggle("bg-blue-500", index === i);
    });
    this.renderMap(coordinates);
  }

  renderMap(coor) {
    let portals = coor
      .split("|")
      .map((x) => x.split(";"))
      .map((x) => x.map((x) => x.split(",")))[0]; // .map(x=>parseFloat(x))
    console.log(portals);
    portals.map((x, i) => {
      if (x[1] != undefined) {
        console.log(`row: ${i+1}`)
        console.log(
          `https://intel.ingress.com/intel?ll=${x[0]},${x[1]}&z=15&pll=${x[0]},${x[1]}`
        );
      }
    });
    const neutaral_icon = L.icon({
      iconUrl: "/neutral.png",
      iconAnchor: [25, 25],
      popupAnchor: [0, -6],
    });
    if (this.map !== undefined) this.map.remove();
    this.map = L.map("canvas").setView(
      portals.find((el) => el.length === 2),
      15
    );
    L.tileLayer.provider("CartoDB.DarkMatter").addTo(this.map);
    let markers = portals.map((x, i) => {
      if (x.length === 2) {
        return L.marker(x, { icon: neutaral_icon }).bindPopup(`<div class='h-30' id='popup-${x.join().replace(/[\D]/g, "")}' data-controller="portal" data-id="${x.join().replace(/[\D]/g, "")}" data-row="${i}" data-col="${this.index}" data-portal-id="${x}">fetch data</div>`, {
          maxWidth : 800,
          minWidth : 150,
          autoPan : true,
          autoPanPadding : L.point(100, 150),
      }).addTo(this.map);
      } else {
        console.log(
          `missing marker for column: ${this.index + 1}, row: ${i + 1}`
        );
      }
    });
    let polyline = L.polyline(
      portals.filter((x) => x.length === 2),
      { color: "#66ccff" }
    ).addTo(this.map);
    this.map.fitBounds(polyline.getBounds(), { padding: [10, 10] });
  }

  portalLog(event) {
    this.stimulate("IfsSearch#info", event.target)
  }
}
