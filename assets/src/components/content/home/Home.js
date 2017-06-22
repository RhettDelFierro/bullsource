import React, {Component} from "react";
import { graphql } from 'react-apollo';
import styles from './style.css';

import Headline from '../../sfc/headline/Headline';

import newsTweetQuery from '../../../queries/fetchNewsTweets'


class Home extends Component {
    renderNewsTweets(){
      return this.props.data.newsTweets.map(newsTweet => <Headline newsTweet={newsTweet} />)
    }

    render() {

        if (this.props.data.loading) {return <div>Loading...</div>}

        return (

            <div className={styles.home}>
                {this.renderNewsTweets()}
            </div>
        )

    }
}

export default graphql(newsTweetQuery)(Home);