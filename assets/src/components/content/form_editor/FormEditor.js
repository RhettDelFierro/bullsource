import React, {Component} from "react";
import {DefaultDraftBlockRenderMap, Editor, EditorState, RichUtils} from "draft-js";
import {Map} from "immutable";
import DOIBlock from "../../sfc/doi_block/DOIBlock";
import styles from "./style.css";
import blockStyles from '../../sfc/doi_block/style.css'

import {getBlockRendererFn} from '../../../helpers/forms'

class FormEditor extends Component {
    constructor(props) {
        super(props);
        this.state = {editorState: EditorState.createEmpty()};
        this.onChange = (editorState) => this.setState({editorState});
        this.handleKeyCommand = this.handleKeyCommand.bind(this);
        this.focus = () => this.refs.editor.focus();
        this.getEditorState = () => this.state.editorState;
        this.blockRendererFn = getBlockRendererFn(this.getEditorState, this.onChange, DOIBlock);
        this.blockRenderMap = Map({
            ['doi_block']: {
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
                    />
                </div>
            </div>

        );
    }
}

export default FormEditor