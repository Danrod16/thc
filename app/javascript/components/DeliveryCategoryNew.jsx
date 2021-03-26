import React from "react"
import PropTypes from "prop-types"

class DeliveryCategoryNew extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      counter: 0,
      orderArray: []
    }
    // check for already checked boxes for edit view and for the case when user
    // uses go back arrow from browser
    console.log('constructor of DeliveryCategoryNew')
    this.prepareElements()
  }

  prepareElements = () => {
    // CategoryName
    console.log('********************************************')
    console.log('categoryNameInput')
    document.getElementById('delivery_category_name').addEventListener('change', (e) => {
      this.handleNameChange(e)
    })

    // RiderId
    console.log('********************************************')
    console.log('categoryRiderIdInput')
    document.getElementById('delivery_category_rider_id').addEventListener('change', (e) => {
      this.handleRiderChange(e)
    })

    // Meals checkboxes
    console.log('********************************************')
    console.log('categoryCheckboxInputs')
    document.querySelectorAll('input[type=checkbox]').forEach((checkbox) => {
      console.log(checkbox, checkbox.dataset)
      console.log(checkbox, checkbox.dataset.sequence)
      checkbox.addEventListener('change', (e) => {
        this.handleCheckBoxChange(e)
      })
    })

    // Form submit button
    console.log('********************************************')
    console.log('categorySubmitButton')
    document.getElementById('new_delivery_category').addEventListener('submit', (e) => {
      this.handleSubmit(e)
    })
  }

  ArrayForReorganizeFetch = () => {
    return this.state.orderArray.map(id => `${id}-Order`)
  }

  handleNameChange = (e) => {
    this.setState({
      deliveryCategoryName: e.target.value
    })
  }

  handleRiderChange = (e) => {
    this.setState({
      deliveryCategoryRiderId: e.target.value
    })
  }

  handleCheckBoxChange = (e) => {
    const checkbox = e.target
    const id = checkbox.value
    let copyArray = [...this.state.orderArray]
    let change = null

    if (checkbox.checked) {
      copyArray.push(id)
      change = 1
    } else {
      copyArray = copyArray.filter((value, index) => value !== id )
      change = -1
    }


    this.setState({
      orderArray: copyArray,
      counter: this.state.counter + change
    })

    console.log(this.state)
  }

  deliveryCategoryData = () => {
    return {
      name: this.state.deliveryCategoryName,
      rider_id: this.state.deliveryCategoryRiderId,
      order_ids: this.state.orderArray
    }
  }

  handleSubmit = (e) => {
    e.preventDefault()
    const authToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
    const createDeliveryCategoryUrl = '/delivery_categories'
    let createDeliveryBody = JSON.stringify({
      delivery_category: this.deliveryCategoryData()
    })
    // let deliveryCategoryId = null

    // Fetch POST to create the new delivery category and store it's ID
    fetch(createDeliveryCategoryUrl, {
      method: "POST",
      headers: {
        'content-type': 'application/json',
        'X-CSRF-TOKEN': authToken
      },
      body: createDeliveryBody
    })
    .then(response => response.json())
    .then(data => {
      const reorderDeliveryCategoryUrl = `/delivery_categories/${data.id}/reorganize`
      const reorderBody = JSON.stringify({
        order_ids: this.ArrayForReorganizeFetch(),
        delivery_category: data.id
      })
      console.log(reorderBody)
      // const orderArray = this.ArrayForReorganizeFetch


      fetch(reorderDeliveryCategoryUrl, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          'X-CSRF-TOKEN': authToken
        },
        body: reorderBody
      })
      .then(response => response.json())
      .then(data => {
        // Simulate a mouse click on a link
        // window.location.href = `delivery_categories/${data.id}/deliveries`
        console.log("fetch #reorganize (last .then) data", data)
        // Replace the URL of the current document (user won't be able to go back to previous page)
        window.location.href = `${data.id}/deliveries`
      })
    })
  }

  render () {
    return (
      <React.Fragment>
        Pedidos selectados: {this.state.counter}
      </React.Fragment>
    );
  }
}

export default DeliveryCategoryNew
