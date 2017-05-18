import * as types from '../types'

const state = {
  registrationErrors: {},
  sessionErrors: {}
}

const getters = {
  [types.GET_REGISTRATION_ERRORS]: state => {
    return state.registrationErrors
  }
}

const mutations = {
  [types.SET_REGISTRATION_ERRORS]: (state, payload) => {
    state.registrationErrors = payload
  }
}

export default {
  state,
  mutations,
  getters
}
