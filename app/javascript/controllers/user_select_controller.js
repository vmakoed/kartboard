import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="user-select"
export default class extends Controller {
  addUser(event) {
    const userId = event.currentTarget.dataset.userId
    const userName = event.currentTarget.dataset.userName

    console.log(userId)
    const userSelect = document.getElementById('contest_contestants_attributes_0_user_id')
    userSelect.value = userId
  }
}
