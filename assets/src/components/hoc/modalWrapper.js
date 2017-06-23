import React, {Component} from "react";
import {graphql} from "react-apollo";
import currentUserQuery from "../../queries/currentUser";

export default (WrappedComponent) => {
    class ModalWrapper extends Component {
        constructor(props) {
            super(props);
            this.state = {
                hamburgerOpened: false,
                dropdownOpened: false
            }
        }

        handleToggleHamburger() {
            this.setState({
                hamburgerOpened: !this.state.hamburgerOpened,
                dropdownOpened: false
            })
        }

        handleToggleDropdown() {
            this.setState({
                dropdownOpened: !this.state.dropdownOpened,
                hamburgerOpened: false
            })
        }

        render() {
            return (
                <WrappedComponent onToggleDropDown={this.handleToggleDropdown.bind(this)}
                                  onToggleHamburger={this.handleToggleHamburger.bind(this)}
                                  modalStates={this.state}
                />
            )
        }
    }
    return graphql(currentUserQuery)(ModalWrapper);
}