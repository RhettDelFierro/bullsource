import React, {Component} from "react";
import {Map} from 'immutable';
import {Editor,EditorState,DefaultDraftBlockRenderMap, RichUtils} from 'draft-js';
import styles from "./style.css";
import {DOI_TYPE, REFERENCE_TYPE, getBlockRendererFn, resetBlockType, getDefaultBlockData} from '../../../helpers/forms';
import DOIBlock from "../doi_block/DOIBlock";

class FormEditor extends Component {
    constructor(props){
        super(props);
        this.state = {editorState: EditorState.createEmpty()};
        this.onChange = (editorState) => this.setState({editorState});
        this.getEditorState = () => this.state.editorState;

        this.blockRenderMap = Map({
            [DOI_TYPE]: {element: 'div'},
            [REFERENCE_TYPE]: {element: 'div'}
        }).merge(DefaultDraftBlockRenderMap);

        this.blockRendererFn = getBlockRendererFn(this.getEditorState, this.onChange);
        this.handleBeforeInput = this.handleBeforeInput.bind(this);
    }

    handleBeforeInput(str) {
        if (str !== ']') {
            return false;
        }
        const { editorState } = this.state;
        /* Get the selection */
        const selection = editorState.getSelection();

        /* Get the current block */
        const currentBlock = editorState.getCurrentContent().getBlockForKey(selection.getStartKey());
        const blockType = currentBlock.getType();
        const blockLength = currentBlock.getLength();
        if (blockLength === 1 && currentBlock.getText() === '[') {
            this.onChange(resetBlockType(editorState, blockType !== DOI_TYPE ? DOI_TYPE : 'unstyled'));
            return true;
        }
        return false;
    }

    blockStyleFn(block) {
        switch (block.getType()) {
            case DOI_TYPE:
                return 'block block-todo';
            default:
                return 'block';
        }
    }


    render() {
        return (
            <div className={styles['form-container']}>
                <Editor editorState={this.state.editorState}
                    ref="editor"
                    placeholder="Write here. Type [ ] to check for a doi..."
                    onChange={this.onChange}
                    blockStyleFn={this.blockStyleFn}
                    blockRenderMap={this.blockRenderMap}
                    blockRendererFn={this.blockRendererFn}
                    handleBeforeInput={this.handleBeforeInput}
                    handleKeyCommand={this.handleKeyCommand} />
            </div>
        )
    }
}

export default FormEditor