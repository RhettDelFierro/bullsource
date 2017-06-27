import React from 'react';
import {graphql} from 'react-apollo';
import { EditorBlock } from 'draft-js';
import styles from './style.css'

import checkDoiQuery from '../../../queries/checkDOI';


import updateDataOfBlock from '../../../helpers/forms';


class DOIBlock extends React.Component {
    constructor(props) {
        super(props);
        this.updateData = this.updateData.bind(this);
    }

    updateData() {
        const { block, blockProps } = this.props;

        // This is the reason we needed a higher-order function for blockRendererFn
        const { onChange, getEditorState } = blockProps;
        const data = block.getData();
        const verified = (data.has('verify') && data.get('verify') === true);
        const newData = data.set('verify', !verified);
        onChange(updateDataOfBlock(getEditorState(), block, newData));
    }

    render() {
        const {doi} = this.props.data;
        const data = this.props.block.getData();
        const verify = data.get('verify') === true;
        return (
            <div className={verify ? `${styles['block-doi-verified']}` : ''}>
                <button onClick={this.updateData}>Verify</button>
                <EditorBlock {...this.props} />
            </div>
        );
    }
}

export default graphql(checkDoiQuery)(DOIBlock);