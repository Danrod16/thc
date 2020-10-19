import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'meals_summary' ];

  connect() {
    setInterval(this.refresh, 20000);
  }

  refresh = () => {
  const path = document.querySelector('.table-responsive-summary').dataset.path;
   fetch(`/${path}`, { headers: { accept: "application/json" } })
   .then(response => response.json())
   .then((data) => {
     this.meals_summaryTarget.innerHTML = ""
     data.meals_summary.forEach( e => {
      this.meals_summaryTarget.insertAdjacentHTML("beforeend",
        `<tr>
        <th>${e[0]}</th>
        <td>${e[1]}</td>
        <td>${e[2]}</td>
        <td>${e[3]}</td>
        <td>${e[4]}</td>
        <td>${e[5]}</td>
        <td>${e[6]}</td>
        </tr>
        `)});
   });
 }
}
