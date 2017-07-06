import React from 'react'
import styles from './style.css'

export const RefenceBlock = (props) => {
    const entity = props.contentState.getEntity(
        props.block.getEntityAt(0)
    );
    const {doi,url,title,source,date,authors} = entity.getData();
    return (
        <div>
            <a href={url}>{title}</a>
            <p>{source}</p>
            <p>{date}</p>
            <p>{authors}</p>
        </div>
    )
};