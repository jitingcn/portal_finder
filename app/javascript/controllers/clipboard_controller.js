import ApplicationController from './application_controller'
import ClipboardJS from 'clipboard'
/* This is the custom StimulusReflex controller for the Clipboard Reflex.
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
  static targets = ["link"]

  connect () {
    super.connect()

    const clipboard = new ClipboardJS(this.linkTarget);

    clipboard.on('success', function(e) {
      console.info('Action:', e.action);
      console.info('Text:', e.text);
      console.info('Trigger:', e.trigger);

      e.clearSelection();
    });

    clipboard.on('error', function(e) {
      console.error('Action:', e.action);
      console.error('Trigger:', e.trigger);
    });
  }

  copy() {
    this.linkTarget.select()
    document.execCommand("copy")
  }
  /* Reflex specific lifecycle methods.
   *
   * For every method defined in your Reflex class, a matching set of lifecycle methods become available
   * in this javascript controller. These are optional, so feel free to delete these stubs if you don't
   * need them.
   *
   * Important:
   * Make sure to add data-controller="clipboard" to your markup alongside
   * data-reflex="Clipboard#dance" for the lifecycle methods to fire properly.
   *
   * Example:
   *
   *   <a href="#" data-reflex="click->Clipboard#dance" data-controller="clipboard">Dance!</a>
   *
   * Arguments:
   *
   *   element - the element that triggered the reflex
   *             may be different than the Stimulus controller's this.element
   *
   *   reflex - the name of the reflex e.g. "Clipboard#dance"
   *
   *   error/noop - the error message (for reflexError), otherwise null
   *
   *   reflexId - a UUID4 or developer-provided unique identifier for each Reflex
   */

  // beforeCopy(element, reflex, noop, reflexId) {
  //  console.log("before copy", element, reflex, reflexId)
  // }

  // copySuccess(element, reflex, noop, reflexId) {
  //   console.log("copy success", element, reflex, reflexId)
  // }

  // copyError(element, reflex, error, reflexId) {
  //   console.error("copy error", element, reflex, error, reflexId)
  // }

  // copyHalted(element, reflex, noop, reflexId) {
  //   console.warn("copy halted", element, reflex, reflexId)
  // }

  // afterCopy(element, reflex, noop, reflexId) {
  //   console.log("after copy", element, reflex, reflexId)
  // }

  // finalizeCopy(element, reflex, noop, reflexId) {
  //   console.log("finalize copy", element, reflex, reflexId)
  // }
}
