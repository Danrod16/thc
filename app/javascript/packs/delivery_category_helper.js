import React from 'react';
import ReactDOM from 'react-dom';

import DeliveryCategoryNew from '../components/DeliveryCategoryNew'

const container = document.getElementById('react-container')

if (container) {
  ReactDOM.render(
   <DeliveryCategoryNew />,
   container
  )
}
