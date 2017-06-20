import React from 'react';
import { NavLink } from 'react-router-dom'
import './style.css'

export const CategoryNav = () => {
    return (
        <ul className='category-nav'>
            <li>
                <NavLink exact activeClassName='active' to='/'>Home</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/entertainment'>Entertainment</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/gaming'>Gaming</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/general'>General</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/music'>Music</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/politics'>Politics</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/science-and-nature'>Science and Nature</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/sport'>Sport</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='/category/technology'>Technology</NavLink>
            </li>
        </ul>
    )
};

