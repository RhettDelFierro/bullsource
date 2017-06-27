import React, {Component} from "react";
import {Editor, EditorState, RichUtils} from "draft-js";
import styles from "./style.css";

class FormEditor extends Component {
    constructor(props) {
        super(props);
        this.state = {editorState: EditorState.createEmpty()};
        this.onChange = (editorState) => this.setState({editorState});
        this.handleKeyCommand = this.handleKeyCommand.bind(this);
        this.focus = () => this.refs.editor.focus();
        this.getEditorState = () => this.state.editorState;
        this.blockRendererFn = getBlockRendererFn(this.getEditorState, this.onChange);

    }

    handleKeyCommand(command) {
        const newState = RichUtils.handleKeyCommand(this.state.editorState, command);
        if (newState) {
            this.onChange(newState);
            return 'handled';
        }
        return 'not-handled';
    }

    _onBoldClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'BOLD'));
        setTimeout(() => this.focus(), 0);
    }

    _onUnderlineClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'UNDERLINE'));
        // setTimeout(() => this.focus(), 0);
    }

    _onItalicClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'ITALIC'));
        setTimeout(() => this.focus(), 0);
    }




    render() {
        return (
            <div className={styles['form-container']}>
                <button onClick={this._onBoldClick.bind(this)}>Bold</button>
                <button onClick={this._onUnderlineClick.bind(this)}>Underline</button>
                <button onClick={this._onItalicClick.bind(this)}>Italic</button>
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