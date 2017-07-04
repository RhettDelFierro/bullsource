import React from "react";
import {Editor, EditorBlock} from "draft-js";
import {Map} from 'immutable';
import {REFERENCE_TYPE,updateTypeOfBlock,getBlockRendererFn} from "../../../helpers/forms";
import ReferenceBlock from '../reference_block/ReferenceBlock';
import styles from "./style.css";

class DOIBlock extends React.Component {
    constructor(props) {
        super(props);
        this.state = {errorMessage: ''};
        this.onVerifyDOI = this.onVerifyDOI.bind(this);
        this.onDOIError = (errorMessage) => this.setState({errorMessage});
        this.keyBindingFn = (e) => this.keyBindingFn(e);
    }

    keyBindingFn(e){
        if(e.key === 'Enter'){
            return this.onVerifyDOI();
        }
    }

    onVerifyDOI() {
        const {block, blockProps} = this.props;
        // This is the reason we needed a higher-order function for blockRendererFn
        const {onChange, getEditorState} = blockProps;
        const text = block.getText();
        // const data = block.getData();
        // const newData = data.set('doi', text);
        // const newData = Map({doi: text});
        onChange(updateTypeOfBlock(getEditorState(), block, REFERENCE_TYPE, text));
    }

    // onVerifyDOI() {
    //     const {block, blockProps} = this.props;
    //     const {onChange, getEditorState} = blockProps;
    //     const editorState = getEditorState();
    //     const contentState = editorState.getCurrentContent();
    //
    //     const text = block.getText();
    //     const data = block.getData();
    //     // const newData = data.set('doi', text);
    //     const newData = Map({doi: text});
    //     onChange(updateTypeOfBlock(getEditorState(), block, REFERENCE_TYPE, newData));
    // }

    render() {
        //maybe const {blockRendererFn, ....rest} = this.props
        //<EditorBlock {...rest} blockRendererFn={this.blockrendererFn}
        return (
            <div className={styles['work-info']}>
                <EditorBlock {...this.props} keyBindingFn={this.keyBindingFn}/>
                <button onClick={this.onVerifyDOI}>Verify DOI</button>
            </div>
        )
    }

}

export default DOIBlock;