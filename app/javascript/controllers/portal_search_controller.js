import ApplicationController from './application_controller'

/* This is the custom StimulusReflex controller for the PortalSearch Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  /*
   * Regular Stimulus lifecycle methods
   * Learn more at: https://stimulusjs.org/reference/lifecycle-callbacks
   *
   * If you intend to use this controller as a regular stimulus controller as well,
   * make sure any Stimulus lifecycle methods overridden in ApplicationController call super.
   *
   * Important:
   * By default, StimulusReflex overrides the -connect- method so make sure you
   * call super if you intend to do anything else when this controller connects.
  */
  static targets = ["input", "result", "oldresult"]

  connect () {
    super.connect()
    console.log("Connected")
    // add your code here, if applicable
  }

  paste (event) {
    console.log("paste")
    let items = event.clipboardData && event.clipboardData.items
    let file = null
    if (items && items.length) {
      for (let i = 0; i < items.length; i++) {
        if (items[i].type.indexOf('image') !== -1) {
          file = items[i].getAsFile()
          break
        }
      }
    }
    if (file) {
      function getBase64(file, onLoadCallback) {
        return new Promise(function(resolve, reject) {
          const reader = new FileReader();
          reader.onload = function() { resolve(reader.result); };
          reader.onerror = reject;
          reader.readAsDataURL(file);
        });
      }
      let image = getBase64(file);
      image.then(result => {
        document.getElementById('input').innerHTML = '<img id="request-image" class="object-contain" src="' + result + '" alt="input">'
        this.oldresultTarget.insertAdjacentHTML('beforeend', this.resultTarget.innerHTML)
        this.resultTarget.innerHTML = ''
        this.stimulate("PortalSearch#run", result)
      })
    }
  }
  /* Reflex specific lifecycle methods.
   *
   * For every method defined in your Reflex class, a matching set of lifecycle methods become available
   * in this javascript controller. These are optional, so feel free to delete these stubs if you don't
   * need them.
   *
   * Important:
   * Make sure to add data-controller="portal-search" to your markup alongside
   * data-reflex="PortalSearch#dance" for the lifecycle methods to fire properly.
   *
   * Example:
   *
   *   <a href="#" data-reflex="click->PortalSearch#dance" data-controller="portal-search">Dance!</a>
   *
   * Arguments:
   *
   *   element - the element that triggered the reflex
   *             may be different than the Stimulus controller's this.element
   *
   *   reflex - the name of the reflex e.g. "PortalSearch#dance"
   *
   *   error/noop - the error message (for reflexError), otherwise null
   *
   *   reflexId - a UUID4 or developer-provided unique identifier for each Reflex
   */

  // Assuming you create a "PortalSearch#dance" action in your Reflex class
  // you'll be able to use the following lifecycle methods:

  // beforeDance(element, reflex, noop, reflexId) {
  //  element.innerText = 'Putting dance shoes on...'
  // }

  // danceSuccess(element, reflex, noop, reflexId) {
  //   element.innerText = 'Danced like no one was watching! Was someone watching?'
  // }

  // danceError(element, reflex, error, reflexId) {
  //   console.error('danceError', error);
  //   element.innerText = "Couldn't dance!"
  // }
}
