import React from 'react'
import DeliveryCategoryBase from './DeliveryCategoryBase'

class DeliveryCategoryNew extends React.Component {

  render () {
    const formId = 'new_delivery_category'
    const submitMethod = 'POST'
    const fetchUrl = '/delivery_categories'

    return (
      <DeliveryCategoryBase
        formId={formId}
        submitMethod={submitMethod}
        fetchUrl={fetchUrl}
        />
    )
  }
}

export default DeliveryCategoryNew
