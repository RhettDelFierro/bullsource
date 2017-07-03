import React from "react";
import {Editor, EditorBlock} from "draft-js";
import {withApollo} from 'react-apollo'
import {Map} from 'immutable';
import {updateDataOfBlock} from "../../../helpers/forms";
import styles from "./style.css";

class DOIBlock extends React.Component {
    constructor(props) {
        super(props);
        this.onVerifyDOI = this.onVerifyDOI.bind(this);
    }

    onVerifyDOI() {

        const {block, blockProps} = this.props;

        // This is the reason we needed a higher-order function for blockRendererFn
        const {onChange, getEditorState} = blockProps;
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
        //maybe const {blockRendererFn, ....rest} = this.props
        //<EditorBlock {...rest} blockRendererFn={this.blockrendererFn}
        return (
            <div className={styles['work-info']}>
                <EditorBlock {...this.props} />
                <button onClick={this.onVerifyDOI}>Verify DOI</button>
            </div>
        )
    }

}

export default withApollo(DOIBlock);