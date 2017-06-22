import React, {Component} from "react";
import {withRouter} from "react-router-dom";
import {graphql} from "react-apollo";
import currentUserQuery from "../../queries/currentUser";

export default (WrappedComponent) => {
    class Auth extends Component {
        constructor(props){
            super(props);
            this.state = {authed: false}
        }

        componentWillUpdate(nextProps) {
            if (!nextProps.data.loading && !nextProps.data.currentUser) {
                this.setState({authed: false});
                //instead of redirect, you can just set state in this component to false.
                //then use that false state to determine if the content should render.

                this.props.history.push('/signin')
            } else {
                this.setState({authed: true})
            }

        }

        render() {
            return <WrappedComponent {...this.props} />
        }
    }
    return graphql(currentUserQuery)(Auth);
}