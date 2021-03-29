import React from "react"
import PropTypes from "prop-types"

class DeliveryCategoryNew extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      counter: 0,
      orderArray: [],
      deliveryCategoryName: '',
      deliveryCategoryRiderId: '',
      missingInputs: ['un nombre', 'un rider', 'un pedido']

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
    this.checkErrors()
  }

  handleRiderChange = (e) => {
    this.setState({
      deliveryCategoryRiderId: e.target.value
    })
    this.checkErrors()
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
    this.checkErrors()
  }

  deliveryCategoryData = () => {
    return {
      name: this.state.deliveryCategoryName,
      rider_id: this.state.deliveryCategoryRiderId,
      order_ids: this.state.orderArray
    }
  }

  checkErrors = () => {
    let missingInputs = []
    if (this.state.deliveryCategoryName === '') {
      missingInputs.push('un nombre')
    }

    if (this.state.deliveryCategoryRiderId === '') {
      missingInputs.push('un rider')
    }

    if (this.state.orderArray.length < 1) {
      missingInputs.push('una pedida')
    }

    if (missingInputs){
      this.setState({
        missingInputs: missingInputs
      })

      return true
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
    const submitButton = document.querySelector('input[type=submit]')
    if (this.state.missingInputs.length > 0) {
      submitButton.disabled = true
      return (
        <React.Fragment>
          <p className='text-warning'>Selecciona {this.state.missingInputs.join(', ')}</p>
          <p>Pedidos seleccionados: {this.state.counter}</p>
        </React.Fragment>
      )
    }

    submitButton.disabled = false
    return (
      <React.Fragment>
        <p>Pedidos seleccionados: {this.state.counter}</p>
      </React.Fragment>
    );
  }
}

export default DeliveryCategoryNew
