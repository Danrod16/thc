import React from "react"
import PropTypes from "prop-types"

class DeliveryCategoryEdit extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      counter: 0,
      orderArray: [],
      deliveryCategoryName: '',
      deliveryCategoryRiderId: '',
    }

    // console.log('constructor of DeliveryCategoryEdit?')
  }

  componentDidMount() {
    this.prepareElements()
  }


  prepareElements = () => {
    // CategoryName
    const nameInput = document.getElementById('delivery_category_name')
    this.setState({
      deliveryCategoryName: nameInput.value
    })
    nameInput.addEventListener('change', (e) => {
      this.handleNameChange(e)
    })

    // RiderId
    const riderInput = document.getElementById('delivery_category_rider_id')
    this.setState({
      deliveryCategoryRiderId: riderInput.value
    })
    riderInput.addEventListener('change', (e) => {
      this.handleRiderChange(e)
    })

    // Meals checkboxes
    let presentSequences = []
    document.querySelectorAll('input[type=checkbox]').forEach((checkbox) => {
      if (checkbox.dataset.sequence !== 'none') {
        console.log('id', checkbox.value)
        console.log('sequence', checkbox.dataset.sequence)
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

    // Form submit button
    const formId = `edit_delivery_category_${this.props.match.params.id}`
    document.getElementById(formId).addEventListener('submit', (e) => {
      this.handleSubmit(e)
    })
  }

  setPresentData = (presentSequences) => {
    console.log('#setPresentData, presentSequences:', presentSequences)
    const presentOrderArray = new Array(presentSequences.length)
    presentSequences.forEach(el => {
      presentOrderArray[el.sequence - 1] = el.id
    })
    console.log('presentOrderArray', presentOrderArray)

    console.log('Before #setPresentData setState() state: ', this.state)

    this.setState({
      counter: presentOrderArray.length,
      orderArray: presentOrderArray
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
  }

  // deliveryCategoryData = () => {
  //   return {
  //     name: this.state.deliveryCategoryName,
  //     rider_id: this.state.deliveryCategoryRiderId,
  //     order_ids: this.state.orderArray
  //   }
  // }

  handleSubmit = (e) => {
    // e.preventDefault()
    const authToken = document.querySelector("meta[name='csrf-token']").getAttribute('content')
    const deliveryId = this.props.match.params.id
    // console.log('deliveryId', deliveryId)
    // console.log(this.state.orderArray)
    // // const createDeliveryCategoryUrl = `/delivery_categories/${deliveryId}`
    // // let createDeliveryBody = JSON.stringify({
    // //   delivery_category: this.deliveryCategoryData()
    // // })
    // // // let deliveryCategoryId = null
    // // console.log('before_fetch', createDeliveryCategoryUrl)
    // // // Fetch POST to create the new delivery category and store it's ID
    // // fetch(`/delivery_categories/${deliveryId}`, {
    // //   method: "PATCH",
    // //   headers: {
    // //     'content-type': 'application/json',
    // //     'X-CSRF-TOKEN': authToken
    // //   },
    // //   body: createDeliveryBody
    // // })
    // // .then(response => response.json())
    // // .then(data => {
      const reorderDeliveryCategoryUrl = `/delivery_categories/${deliveryId}/reorganize`
      const reorderBody = JSON.stringify({
        order_ids: this.ArrayForReorganizeFetch()
      })
      // console.log(reorderBody)
      // const orderArray = this.ArrayForReorganizeFetch


      fetch(reorderDeliveryCategoryUrl, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          'X-CSRF-TOKEN': authToken
        },
        body: reorderBody
      })
    //   .then(response => response.json())
    //   .then(data => {
    //     // window.location.href = `/deliveries`
    //   })

    //   // window.location.href = `/deliveries`
    // // })
  }

  render () {
    // console.log(this.state)
    return (
      <React.Fragment>
        Pedidos selectados: {this.state.counter}
      </React.Fragment>
    );
  }
}

export default DeliveryCategoryEdit
