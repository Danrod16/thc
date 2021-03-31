import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'

import DeliveryCategoryNew from '../components/DeliveryCategoryNew'
import DeliveryCategoryEdit from '../components/DeliveryCategoryEdit'
import DeliveryCategoryBase from '../components/DeliveryCategoryBase'

const container = document.getElementById('react-container')

if (container) {
  ReactDOM.render(
    <Router>
      <Switch>
        <Route exact path='/delivery_categories/new' component={DeliveryCategoryNew} />
        <Route exact path='/delivery_categories/:id/edit' component={DeliveryCategoryEdit} />
      </Switch>
    </Router>
   ,container
  )
}
