import React, {Component} from "react";
import {graphql} from "react-apollo";
import { Link, withRouter } from "react-router-dom";
import newsTweetFilterQuery from "../../../queries/fetchFilterNewsTweets";
import Headline from "../../sfc/headline/Headline";
import styles from './style.css'

class Categories extends Component {
    renderNewsTweets() {
        return this.props.data.newsTweetsBy.map(newsTweet => <Headline newsTweet={newsTweet}/>)
    }

    render() {

        if (this.props.data.loading) {
            return <div>Loading...</div>
        }

        return (

            <div className={styles.content}>
                <Link to="/">
                    <div height="500px" width="100%">
                        Home - This will eventually be the header
                    </div>
                </Link>
                {this.renderNewsTweets()}
            </div>
        )
    }
}


export default graphql(newsTweetFilterQuery, {
    options: (props) => {
        return {variables: {category: props.match.params.category}}
    }
})(withRouter(Categories));