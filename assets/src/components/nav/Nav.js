import React from 'react';
import { NavLink } from 'react-router-dom'
import './style.css'

export const Nav = () => {
    return (
        <ul className='nav'>
            <li>
                <NavLink exact activeClassName='active' to='/'>Home</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/signup'>Sign-Up</NavLink>
            </li>
        </ul>
    )
};

