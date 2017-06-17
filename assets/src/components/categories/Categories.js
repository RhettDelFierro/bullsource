import React, {Component} from "react";
import { graphql } from "react-apollo";
import {Link, withRouter} from "react-router-dom";
import newsTweetFilterQuery from "../../queries/fetchFilterNewsTweets";
import Headline from "../headline/Headline"

class Categories extends Component {
    renderNewsTweets(){
        console.log(this.props.data.newsTweetsBy);
        return this.props.data.newsTweetsBy.map(newsTweet => <Headline newsTweet={newsTweet} />)
    }

    render() {

        if (this.props.data.loading) {return <div>Loading...</div>}

        return (

            <div>
                {this.renderNewsTweets()}
            </div>
        )
    }}


export default graphql(newsTweetFilterQuery,{
    options: (props) => { return { variables: { category: props.match.params.category } } }
})(withRouter(Categories));