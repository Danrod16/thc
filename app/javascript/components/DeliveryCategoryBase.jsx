import React from 'react'

class DeliveryCategoryBase extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      counter: 0,
      orderArray: [],
      deliveryCategoryName: '',
      deliveryCategoryRiderId: '',
      missingInputs: []
    }
  }

  componentDidMount() {
    if (this.props.formId){
      this.addEventListenersAndData()
    }
  }

  addEventListenersAndData = () => {
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
    const form = document.getElementById(this.props.formId)
    form.addEventListener('submit', (e) => this.handleSubmit(e))

    // Current data
    const currentOrderArray = getCurrentCheckboxesData(deliveryCheckboxes)
    console.log("addEventListenersAndData currentOrderArray: ", currentOrderArray)
    this.setState({
      counter: currentOrderArray.length,
      orderArray: currentOrderArray,
      deliveryCategoryName: deliveryCategoryName.value,
      deliveryCategoryRiderId: deliveryCategoryRiderId.value
    }, this.checkErrors)
  }

  // Name Handler --------------------------------------------------------------
  handleNameChange = (e) => {
    this.setState({
      deliveryCategoryName: e.target.value
    })
    this.checkErrors()
  }

  // Rider Handler -------------------------------------------------------------
  handleRiderChange = (e) => {
    this.setState({
      deliveryCategoryRiderId: e.target.value
    })
    this.checkErrors()
  }

  // Checkbox Handler ----------------------------------------------------------
  handleCheckBoxChange = (e) => {
    const checkbox = e.target
    const id = checkbox.value
    let copyArray = [...this.state.orderArray]

    checkbox.checked ?
      copyArray.push(id) :
      copyArray = copyArray.filter((value, index) => value !== id )
    console.log("handleCheckBoxChange orderArray", copyArray)
    this.setState({
      orderArray: copyArray,
      counter: copyArray.length
    })
    this.checkErrors()
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

    // check if this works when removing an input in edit
    if (missingInputs){
      this.setState({
        missingInputs: missingInputs
      })

      return true
    }
  }

  // Submit Handler ------------------------------------------------------------
  handleSubmit = (e) => {
    e.preventDefault()
    const authToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')

    fetch(this.props.fetchUrl, {
      method: this.props.submitMethod,
      headers: {
        'content-type': 'application/json',
        'X-CSRF-TOKEN': authToken
      },
      body: this.deliveryDataObject()
    })
    .then(response => response.json())
    .then(data => window.location.href = `/delivery_categories/${data.id}/deliveries`)
  }

  arrayForReorganizeFetch = () => {
    return this.state.orderArray.map(id => `${id}-Order`)
  }

  deliveryDataObject = () => {
    console.log("deliveryDataObject", this.arrayForReorganizeFetch())
    return JSON.stringify({
      delivery_category: {
        name: this.state.deliveryCategoryName,
        rider_id: this.state.deliveryCategoryRiderId,
        order_ids: this.state.orderArray
      },
      sequence_array: this.arrayForReorganizeFetch()
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

  presentSequences.sort((order1, order2) => order1.sequence - order2.sequence)
  const presentOrderArray = new Array(presentSequences.length)
  presentSequences.forEach((el, index) => {
    presentOrderArray[index] = el.id
  })

  return presentOrderArray
}

export default DeliveryCategoryBase
