import React from "react"
import PropTypes from "prop-types"

class DeliveryCategoryEdit extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      counter: 0,
      orderArray: [],
      deliveryCategoryName: '',
      deliveryCategoryRiderId: ''
    }
  }

  componentDidMount() {
    this.addEventListenersToForm()
  }

  addEventListenersToForm = () => {
    // Name
    const deliveryCategoryName = document.getElementById('delivery_category_name')
    deliveryCategoryName.addEventListener('change', (e) => this.handleNameChange(e))

    // Rider
    const deliveryCategoryRiderId = document.getElementById('delivery_category_rider_id')
    deliveryCategoryRiderId.addEventListener('change', (e) => this.handleRiderChange(e))

    // Checkboxes
    const deliveryCheckboxes = document.querySelectorAll('input[type=checkbox]')
    deliveryCheckboxes.forEach((checkbox) => {
      checkbox.addEventListener('change', (e) => this.handleCheckBoxChange(e))
    })

    // Form
    const form = document.getElementById(`edit_delivery_category_${this.props.match.params.id}`)
    form.addEventListener('submit', (e) => this.handleSubmit(e))

    // Current orderArray
    const currentOrderArray = getCurrentCheckboxesData(deliveryCheckboxes)
    this.setState({
      counter: currentOrderArray.length,
      orderArray: currentOrderArray,
      deliveryCategoryName: deliveryCategoryName.value,
      deliveryCategoryRiderId: deliveryCategoryRiderId.value
    })
  }

  // Name Handler --------------------------------------------------------------
  handleNameChange = (e) => {
    this.setState({
      deliveryCategoryName: e.target.value
    })
  }

  // Rider Handler -------------------------------------------------------------
  handleRiderChange = (e) => {
    this.setState({
      deliveryCategoryRiderId: e.target.value
    })
  }

  // Checkbox Handler ----------------------------------------------------------
  handleCheckBoxChange = (e) => {
    const checkbox = e.target
    const id = checkbox.value
    let copyArray = [...this.state.orderArray]
    let change = null

    checkbox.checked ?
      copyArray.push(id) :
      copyArray = copyArray.filter((value, index) => value !== id )

    this.setState({
      orderArray: copyArray,
      counter: copyArray.length
    })
    console.log(this.state.orderArray)
  }

  ArrayForReorganizeFetch = () => {
    return this.state.orderArray.map(id => `${id}-Order`)
  }

  deliveryDataObject = () => {
    return JSON.stringify({
      delivery_category: {
        name: this.state.deliveryCategoryName,
        rider_id: this.state.deliveryCategoryRiderId,
        order_ids: this.state.orderArray
      },
      sequence_array: this.ArrayForReorganizeFetch()
    })
  }

  handleSubmit = (e) => {
    e.preventDefault()
    const authToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
    const deliveryId = this.props.match.params.id
    const orderUpdatePath = `/delivery_categories/${deliveryId}`
    const reorderDeliveryCategoryPath = `/delivery_categories/${deliveryId}/reorganize`

    console.log(this.deliveryDataObject())
    fetch(orderUpdatePath, {
      method: 'PATCH',
      headers: {
        'content-type': 'application/json',
        'X-CSRF-TOKEN': authToken
      },
      body: this.deliveryDataObject()
    })
    .then(response => console.log(response))
    .then(data => window.location.href = `/delivery_categories/${deliveryId}/deliveries`)
  }


  render () {
    console.log(this.state.orderArray)
    return (
      <React.Fragment>
        Pedidos seleccionados: {this.state.counter}
      </React.Fragment>
    )
  }
}

function getCurrentCheckboxesData(checkboxes) {
  let presentSequences = []
  checkboxes.forEach((checkbox) => {
    if (checkbox.dataset.sequence !== 'none') {
      presentSequences.push({
        id: checkbox.value,
        sequence: parseInt(checkbox.dataset.sequence)
      })
    }
  })

  const presentOrderArray = new Array(presentSequences.length)
  presentSequences.forEach(el => {
    presentOrderArray[el.sequence - 1] = el.id
  })

  return presentOrderArray
}

function fetchDeliveryEdit() {

}

export default DeliveryCategoryEdit
