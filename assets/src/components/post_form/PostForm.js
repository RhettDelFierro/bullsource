import React, { Component } from 'react';
import { graphql } from 'react-apollo'

import threadMutation from "../../createThread"
import postMutation from "../../mutations/createPost"

class PostForm extends Component {
    constructor(props) {
        super(props)

        this.state = {
            
        }
    }


    onSubmit(event){

    }

    render() {
        return (
            <div>
                <form onSubmit={this.onSubmit.bind(this)}>
                    <label>Song Title:</label>
                    <input
                        onChange={event => this.setState({ title: event.target.value })}
                        value={this.state.title}
                    />

                </form>
                The PostForm goes here.
            </div>
        )
    }
}

// we'll create this as a thread first, then run the approriate mutation
//   - maybe graphql(postMutation)(graphql(threadMutation)(PostForm)) ??

// maybe write a query to run a check in database if this is a thread?
export default graphql(threadMutation)(PostForm);