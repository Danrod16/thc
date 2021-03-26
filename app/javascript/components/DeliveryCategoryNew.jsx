import React from "react"
import PropTypes from "prop-types"

class DeliveryCategoryNew extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      counter: 0,
      orderArray: []
    }

    this.prepareElements()
  }

  prepareElements = () => {
    // CategoryName
    document.getElementById('delivery_category_name').addEventListener('change', (e) => {
      this.handleNameChange(e)
    })

    // RiderId
    document.getElementById('delivery_category_rider_id').addEventListener('change', (e) => {
      this.handleRiderChange(e)
    })

    // Meals checkboxes
    document.querySelectorAll('input[type=checkbox]').forEach((checkbox) => {
      console.log(checkbox, checkbox.dataset)
      console.log(checkbox, checkbox.dataset.sequence)
      checkbox.addEventListener('change', (e) => {
        this.handleCheckBoxChange(e)
      })
    })

    // Form submit button
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

    checkbox.checked ?
      copyArray.push(id) :
      copyArray = copyArray.filter((value, index) => value !== id )

    this.setState({
      orderArray: copyArray,
      counter: copyArray.length
    })
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
        window.location.href = `${data.id}/deliveries`
      })
    })
  }

  render () {
    return (
      <React.Fragment>
        Pedidos seleccionados: {this.state.counter}
      </React.Fragment>
    );
  }
}

export default DeliveryCategoryNew
