import React,{Component} from 'react';
import {graphql} from 'react-apollo';
import proofMutation from "../../../mutations/proofMutation"

class ProofFrom extends Component{
    render(){
        return(
            <form>
                <input type="text" placeholder="enter doi"/>
            </form>
        )
    }
}

export default graphql(proofMutation)(ProofForm)