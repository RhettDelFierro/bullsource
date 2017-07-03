import React from "react";
import {graphql} from "react-apollo";
import {EditorBlock, EditorState} from 'draft-js';
import {updateDataOfBlock} from "../../../helpers/forms"
import styles from "./style.css";

import checkDoiQuery from "../../../queries/checkDOI";

class DOIBlock extends React.Component {
    constructor(props){
      super(props);
      this.onVerifyDOI = this.onVerifyDOI;
    }

    onVerifyDOI(){
        e.preventDefault();

        const { block, blockProps } = this.props;

        // This is the reason we needed a higher-order function for blockRendererFn
        const { onChange, getEditorState } = blockProps;
        const text = block.getText();
        const data = block.getData();
        const newData = data.set('doi', text);
        onChange(updateDataOfBlock(getEditorState(), block, newData));
    }


    renderWork() {

        const data = this.props.node.data;
        const authors = this.props.data.error ? '' : data.get('authors').map(author => author + ', ');
        return this.props.data.error ? <div/> :
            <div className={styles['work-info']}>
                <a href={data.get('url')}>{data.get('title')}</a>
                <p>{data.get('source')}</p>
                <p>{data.get('date')}</p>
                <p>{authors}</p>
            </div>
    }

    render() {
        console.log(this.props);
        return (
            <div>
              <EditorBlock {...this.props} />
                <button onClick={this.onVerifyDOI}>Verify DOI</button>
            </div>
        )
    }

}

export default graphql(checkDoiQuery, {
    options: (props) => {
        const doi = props.data.doi;
        return {variables: {doi}}
    },
    name: 'checkDOIQuery'
})(DOIBlock);