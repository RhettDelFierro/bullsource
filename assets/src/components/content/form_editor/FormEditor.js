import React, {Component} from "react";
import {DefaultDraftBlockRenderMap, Editor, EditorState, RichUtils} from "draft-js";
import {Map} from "immutable";
import DOIBlock from "../../sfc/doi_block/DOIBlock";
import styles from "./style.css";
import blockStyles from '../../sfc/doi_block/style.css'

import {getBlockRendererFn, resetBlockType} from '../../../helpers/forms'

const DOI_BLOCK = 'doi_block';

class FormEditor extends Component {
    constructor(props) {
        super(props);
        this.state = {editorState: EditorState.createEmpty()};
        this.onChange = (editorState) => this.setState({editorState});
        this.handleBeforeInput = this.handleBeforeInput.bind(this);
        this.handleKeyCommand = this.handleKeyCommand.bind(this);
        this.focus = () => this.refs.editor.focus();
        this.getEditorState = () => this.state.editorState;
        this.blockRendererFn = getBlockRendererFn(this.getEditorState, this.onChange, DOIBlock);
        this.blockRenderMap = Map({
            [DOI_BLOCK]: {
                element: 'div',
            },
        }).merge(DefaultDraftBlockRenderMap);

    }

    handleKeyCommand(command) {
        const newState = RichUtils.handleKeyCommand(this.state.editorState, command);
        if (newState) {
            this.onChange(newState);
            return 'handled';
        }
        return 'not-handled';
    }

    onBoldClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'BOLD'));
        setTimeout(() => this.focus(), 0);
    }

    onUnderlineClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'UNDERLINE'));
        // setTimeout(() => this.focus(), 0);
    }

    onItalicClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'ITALIC'));
        setTimeout(() => this.focus(), 0);
    }

    blockStyleFn(block) {
        switch (block.getType()) {
            case DOI_BLOCK:
                return `${blockStyles.block} ${blockStyles['block-doi']}`;
            default:
                return `${blockStyles.block}`;
        }
    }

    handleBeforeInput(str) {
        if (str !== ']') {
            return false;
        }
        const { editorState } = this.state;
        /* Get the selection */
        const selection = editorState.getSelection();

        /* Get the current block */
        const currentBlock = editorState.getCurrentContent()
            .getBlockForKey(selection.getStartKey());
        const blockType = currentBlock.getType();
        const blockLength = currentBlock.getLength();
        if (blockLength === 1 && currentBlock.getText() === '[') {
            this.onChange(resetBlockType(editorState, blockType !== DOI_BLOCK ? DOI_BLOCK : 'unstyled'));
            return true;
        }
        return false;
    }


    render() {
        return (
            <div className={styles['form-container']}>
                <button onClick={this.onBoldClick.bind(this)}>Bold</button>
                <button onClick={this.onUnderlineClick.bind(this)}>Underline</button>
                <button onClick={this.onItalicClick.bind(this)}>Italic</button>
                <div className={styles.editor} onClick={this.focus}>
                    <Editor editorState={this.state.editorState}
                            onChange={this.onChange}
                            handleKeyCommand={this.handleKeyCommand}
                            ref="editor"
                            blockRendererFn={this.blockRendererFn}
                            blockStyleFn={this.blockStyleFn}
                            blockRenderMap={this.blockRenderMap}
                            handleBeforeInput={this.handleBeforeInput}
                    />
                </div>
            </div>

        );
    }
}

export default FormEditor