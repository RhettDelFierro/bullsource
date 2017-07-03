import React, {Component} from "react";
import {graphql} from "react-apollo";
import checkDOIQuery from "../../../queries/checkDOI";

class ReferenceBlock extends Component {
    render() {
        const {loading} = this.props.data;
        return (
            loading ?
                <div>Loading</div>
                :
                <div>blah</div>

        )
    }


}

export default graphql(checkDOIQuery, {
    options: (props) => {
        const {block, blockProps} = props;
        const data = block.getData();
        const doi = data.get('doi');
        return {variables: {doi}}
    }
})(ReferenceBlock);