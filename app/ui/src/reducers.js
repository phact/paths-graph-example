import {combineReducers} from 'redux';
import {handleAction} from 'redux-actions';
import {routerReducer} from 'react-router-redux';
import keplerGlReducer from 'kepler.gl/reducers';
import RequestReducer from './requestReducers.js'

import Graph from './common/graph';
import LayoutEngine from './common/layout-engine';


// INITIAL_APP_STATE
const initialAppState = {
  appName: 'Powertrain Viewer',
  viewport: {
    width: 1000,
    height: 700
  },
  graph: new Graph(),
  hoveredNodeID: null,
  engine: {}
};

const reducers = combineReducers({
  // mount keplerGl reducer
  RequestReducer,
  keplerGl: keplerGlReducer,
  app: handleAction(
      'UPDATE',
      (state, action) => ({
          ...state,
          [action.data.key] : action.data.value
      }),
      initialAppState
  ),
  interval: handleAction(
      'SET_INTERVAL',
      (state, action) => ({
          ...state,
          value : action.data
      }),null
  ),
  routing: routerReducer
});

export default reducers;
