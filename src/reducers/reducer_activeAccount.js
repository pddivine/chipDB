import { ACTIVE_ACCOUNT } from '../actions/activeAccount';

export default function (state = null, action) {
  switch (action.type) {
    case ACTIVE_ACCOUNT:
      console.log(action);
      return action.payload;
    default: return state;
  }
}