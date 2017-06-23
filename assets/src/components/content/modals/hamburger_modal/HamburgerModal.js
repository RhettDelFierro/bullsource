import React,{Component} from 'react';
import {graphql} from 'react-apollo';

import currentUserQuery from "../../../../queries/currentUser"
import styles from './style.css';


class HamburgerModal extends Component{
    constructor(props){
        super(props);

    }
    render(){
        return(
            <div className={styles.overlay}>

            </div>
        )
    }
}

export default graphql(currentUserQuery)(HamburgerModal)