import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-select"
export default class extends Controller {
  static targets = [ "user", "contestant", "dialog", "addPlayerButton" ]

  initialize() {
    this.index = 0
    this.maxUsers = this.userTargets.length
  }

  connect() {
    this.userTargets.forEach((user, index) => {
      console.log(user.value)
      if (user.value !== "") {
        this.showContestantField(index)
      }
    })

    const emptyUserIndex = this.userTargets.findIndex(user => user.value === "")
    if (emptyUserIndex !== -1) {
      this.index = emptyUserIndex
    } else {
      this.index = this.maxUsers
    }
  }

  addUser(event) {
    this.assignUser(event.currentTarget.dataset.userId)
    this.showContestantField(this.index)
    this.nextPlayer()
    this.dialogTarget.close()
  }

  assignUser(userId) {
    const user = this.userTargets[this.index]
    user.value = userId
  }

  showContestantField(index) {
    const contestant = this.contestantTargets[index]
    contestant.classList.remove('hidden')
    contestant.hidden = false
  }

  nextPlayer() {
    if (this.index < this.maxUsers - 1) {
      this.index++

      if (this.isCurrentPlayerAssigned()) {
        this.nextPlayer()
      }
    } else {
      this.addPlayerButtonTarget.classList.add('hidden')
    }
  }

  isCurrentPlayerAssigned() {
    const user = this.userTargets[this.index]
    return user.value !== ""
  }
}
