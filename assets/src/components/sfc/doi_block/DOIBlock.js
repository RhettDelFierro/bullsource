import React from 'react';
import {graphql} from 'react-apollo';
import { EditorBlock } from 'draft-js';
import styles from './style.css'

import checkDoiQuery from '../../../queries/checkDOI';


import {updateDataOfBlock} from '../../../helpers/forms';


class DOIBlock extends React.Component {
    constructor(props) {
        super(props);
        this.updateData = this.updateData.bind(this);
    }

    updateData() {
        const { block, blockProps } = this.props;
        const doi = block.getText();

        // This is the reason we needed a higher-order function for blockRendererFn
        const { onChange, getEditorState } = blockProps;
        const data = block.getData();
        const newData = data.set('doi', doi);
        // console.log(block.getData());
        // const verified = (data.has('verify') && data.get('verify') === true);
        // const newData = data.set('verify', !verified);
        onChange(updateDataOfBlock(getEditorState(), block, newData));
    }


    render() {
        const data = this.props.block.getData();
        console.log('block data .getdata()', data);
        const verify = data.get('verify') === true;
        console.log('doi', this.props.data);
        return (
            <div className={verify ? `${styles['block-doi-verified']}` : ''}>
                <label>Enter the DOI here:</label>
                <EditorBlock {...this.props} />
                {/*<button onClick={this.updateData}>Verify</button>*/}
                <button onClick={this.updateData}>Verify</button>
            </div>
        );
    }
}

export default graphql(checkDoiQuery,{
    // skip: (props) => {
    //     const data = props.block.getData();
    //     return data.get('doi') ? false : true
    // },

    options: (props) => {
        const doi = props.block.getData().get('doi');
        return {variables: {doi}}
    }
})(DOIBlock);