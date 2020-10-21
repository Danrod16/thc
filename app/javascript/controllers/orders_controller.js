import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'mealsRaw', 'snacksRaw', 'dessertsRaw',
                     'mealsSummary', 'snacksSummary', 'dessertsSummary', 'totalOrders' ];

  connect() {
    setInterval(this.refresh, 120000);
  }

  refresh = () => {
  const path = document.querySelector('.tab-content').dataset.path;
   fetch(`/${path}`, { headers: { accept: "application/json" } })
   .then(response => response.json())
   .then((data) => {

    // Meals raw table
    this.mealsRawTarget.innerHTML = ""
    data.meals.forEach( e => {
      this.mealsRawTarget.insertAdjacentHTML("beforeend",
        `<tr>
          <td>${e.meal_date}</td>
          <td>${e.customer_name}</td>
          <td>${e.meal_size}</td>
          <td>${e.meal_protein}</td>
          <td>${e.meal_custom}</td>
          <td>${e.notes}</td>
        </tr>`)});

    // Meals summary table
    this.mealsSummaryTarget.innerHTML = ""
    data.meals_summary.forEach( e => {
      this.mealsSummaryTarget.insertAdjacentHTML("beforeend",
        `<tr>
          <th>${e[0]}</th>
          <td>${e[1]}</td>
          <td>${e[2]}</td>
          <td>${e[3]}</td>
          <td>${e[4]}</td>
          <td>${e[5]}</td>
          <td>${e[6]}</td>
        </tr>`)});

    // Snacks raw table
    this.snacksRawTarget.innerHTML = ""
    data.snacks.forEach( e => {
      this.snacksRawTarget.insertAdjacentHTML("beforeend",
        `<tr>
          <td>${e.meal_date}</td>
          <td>${e.customer_name}</td>
          <td>${e.meal_name}</td>
          <td>${e.notes}</td>
        </tr>`)});

    // Snacks summary table
    this.snacksSummaryTarget.innerHTML = ""
    data.snacks_summary.forEach( e => {
      this.snacksSummaryTarget.insertAdjacentHTML("beforeend",
        `<tr>
          <th>${e[0]}</th>
          <td>${e[1]}</td>
        </tr>`)});

    // Desserts raw table
    this.dessertsRawTarget.innerHTML = ""
    data.desserts.forEach( e => {
    this.dessertsRawTarget.insertAdjacentHTML("beforeend",
      `<tr>
        <td>${e.meal_date}</td>
        <td>${e.customer_name}</td>
        <td>${e.meal_name}</td>
        <td>${e.notes}</td>
      </tr>`)});

    // Desserts summary table
    this.dessertsSummaryTarget.innerHTML = ""
    data.desserts_summary.forEach( e => {
      this.dessertsSummaryTarget.insertAdjacentHTML("beforeend",
        `<tr>
          <th>${e[0]}</th>
          <td>${e[1]}</td>
        </tr>`)});

    // Total orders
    this.totalOrdersTarget.innerHTML = `<strong>Total pedidos de hoy: ${data.total_orders}</strong>`

    });
 }
}
