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
  static targets = ["input", "results", "history"]

  static values = {
    results: String,
    resultName: String
  }

  connect () {
    super.connect()
    if (this.element.tagName !== "BUTTON") {
      this.showHistory()
    }
  }

  save (event) {
    this.addHistory([JSON.parse(this.resultsValue)])
    this.showHistory()
    document.getElementById('results').innerHTML = ""
    document.getElementById('input').innerHTML = ""
  }

  remove() {
    let removeName = this.resultNameValue
    let history = localStorage.getItem("PortalSearchResults");
    if (history) {
      history = JSON.parse(history)
      _.remove(history, function (e) {
        console.log(e.name)
        return e.name === removeName
      })
    }
    console.log(history)
    localStorage.setItem("PortalSearchResults", JSON.stringify(history))
    this.showHistory()
  }

  addHistory (newHistory) {
    let history = localStorage.getItem("PortalSearchResults");
    if (history) {
      history = _.uniqBy(_.concat(newHistory, JSON.parse(history)), function(item) { return item.name } )
    } else {
      history = newHistory
    }
    localStorage.setItem("PortalSearchResults", JSON.stringify(history))
    return history
  }

  showHistory() {
    let history = localStorage.getItem("PortalSearchResults");
    if (history == null) return
    history = JSON.parse(history)
    document.getElementById("history").innerHTML = ""
    let html = ""
    history.forEach(function (e) {
      html += `<div class="rounded-lg shadow-md bg-gradient-to-r from-green-300 to-blue-400 flex w-full h-32 mb-2" data-controller="clipboards">
<div class="rounded-l-lg overflow-hidden w-1/3 h-32 mr-2">
<img class="w-full h-full object-cover" alt="${e.name}" src="${e.image_url}">
</div>
<div class="w-2/3 flex flex-col my-1">
<div class="inline flex flex-col justify-between mt-2 mb-1 mr-2">
<span class="text-lg font-medium truncate">${e.name}</span>
<span class="text-xs font-normal self-end truncate">${e.coordinate}</span>
</div>
<div class="flex flex-auto items-center justify-between mr-2">
<a class="mr-2 flex" href="https://intel.ingress.com/?pll=${e.coordinate}" rel="noopener noreferrer" target="_blank">
<span class="mr-1">Intel</span>
<svg class="w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
</svg>
</a>
<button class="mr-2 flex" data-action="clipboards#event" data-clipboard-text="https://intel.ingress.com/?pll=${e.coordinate}" data-clipboards-target="link">
<span class="mr-1">Copy</span>
<svg class="w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3"></path>
</svg>
</button>
<button class="mr-2 flex" data-action="portal-search#remove" data-controller="portal-search" data-portal-search-result-name-value="${e.name}">
  <span class="mr-1">Remove</span>
  <svg class="w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
  </svg>
</button></div></div></div>`
    })
    document.getElementById("history").innerHTML = html
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
        document.getElementById('input').innerHTML = '<img id="request-image" class="z-50 w-full h-48 object-contain" src="' + result + '" alt="input">'
        // this.oldresultTarget.insertAdjacentHTML('beforeend', this.resultTarget.innerHTML)
        this.resultsTarget.innerHTML = ''
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
