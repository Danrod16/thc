import React from 'react'
import DeliveryCategoryBase from './DeliveryCategoryBase'

class DeliveryCategoryEdit extends DeliveryCategoryBase {

  render () {
    const deliveryId = this.props.match.params.id
    const formId = `edit_delivery_category_${deliveryId}`
    const submitMethod = 'PATCH'
    const fetchUrl = `/delivery_categories/${deliveryId}`
    return (
      <DeliveryCategoryBase
        formId={formId}
        submitMethod={submitMethod}
        fetchUrl={fetchUrl}
        />
    )
  }
}

export default DeliveryCategoryEdit
