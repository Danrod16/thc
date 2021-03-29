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
    this.prepareElements()
  }


  prepareElements = () => {
    // CategoryName ------------------------------------------------------------
    this.setState({
      deliveryCategoryRiderId: document.getElementById('delivery_category_rider_id')
      deliveryCategoryName: document.getElementById('delivery_category_name')
    })
    nameInput.addEventListener('change', (e) => {
      this.handleNameChange(e)
    })

    // RiderId -----------------------------------------------------------------
    this.setState({
    })
    riderInput.addEventListener('change', (e) => {
      this.handleRiderChange(e)
    })

    // Meals checkboxes --------------------------------------------------------
    let presentSequences = []
    document.querySelectorAll('input[type=checkbox]').forEach((checkbox) => {
      if (checkbox.dataset.sequence !== 'none') {
        presentSequences.push({
          id: checkbox.value,
          sequence: parseInt(checkbox.dataset.sequence)
        })
      }

      checkbox.addEventListener('change', (e) => {
        this.handleCheckBoxChange(e)
      })
    })
    this.setPresentData(presentSequences)

    // Form --------------------------------------------------------------------
    const formId = `edit_delivery_category_${this.props.match.params.id}`
    document.getElementById(formId).addEventListener('submit', (e) => {
      this.handleSubmit(e)
    })
  }
  // Set Previous Data in State ------------------------------------------------
  setPresentData = (presentSequences) => {
    const presentOrderArray = new Array(presentSequences.length)
    presentSequences.forEach(el => {
      presentOrderArray[el.sequence - 1] = el.id
    })

    this.setState({
      counter: presentOrderArray.length,
      orderArray: presentOrderArray
    })
  }

  // Arrat as expected by DeliveryCategory#Reorganize --------------------------
  ArrayForReorganizeFetch = () => {
    return this.state.orderArray.map(id => `${id}-Order`)
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
  }

  handleSubmit = (e) => {
    e.preventDefault()
    const authToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
    const deliveryId = this.props.match.params.id
    const reorderDeliveryCategoryUrl = `/delivery_categories/${deliveryId}/reorganize`

    debugger
    const formData = getFormData(e.target)

    // const submitEvent = new Event('submit')

    // const reorderBody = JSON.stringify({
    //   order_ids: this.ArrayForReorganizeFetch()
    // })

    // fetch(reorderDeliveryCategoryUrl, {
    //   method: 'POST',
    //   headers: {
    //     'content-type': 'application/json',
    //     'X-CSRF-TOKEN': authToken
    //   },
    //   body: reorderBody
    // })
    // // this enters infinite loop
    // // .then(response => e.target.dispatchEvent(submitEvent))
  }

  render () {
    return (
      <React.Fragment>
        Pedidos seleccionados: {this.state.counter}
      </React.Fragment>
    )
  }
}

function getFormData(form) {
  console.log(form)
}

function fetchDeliveryEdit() {

}

export default DeliveryCategoryEdit
