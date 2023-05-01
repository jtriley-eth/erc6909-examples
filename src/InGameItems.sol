// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "lib/ERC-6909/src//ERC6909.sol";
import {Permission, newPermission} from "src/utils/Permission.sol";

contract InGameItems is ERC6909 {
    error CannotSwapMainForMain();

    event RegisteredItem(uint256 indexed id, uint8 decimals, uint256 price);
    event UpdatedDecimals(uint256 indexed id, uint8 decimals);
    event UpdatedPrice(uint256 indexed id, uint256 price);

    uint256 internal currencyIdCounter;
    uint256 public constant main = 0;
    mapping(uint256 id => uint256 rate) public prices;
    mapping(address account => Permission permission) public permissions;

    constructor() {
        permissions[msg.sender] = newPermission().setAdmin(true);
        registerItem(decimals, 0);
    }

    function registerItem(uint8 decimals, uint256 price) public {
        permissions[msg.sender].requireAdmin();
        uint256 id = currencyIdCounter++;
        decimals[id] = decimals;
        prices[id] = price;
        emit RegisteredItem(id, decimals, price);
    }

    function sell(uint256 id, uint256 amount) public {
        if (id == main) revert CannotSwapMainForMain();
        balanceOf[msg.sender][id] -= amount;
        balanceOf[msg.sender][main] += amount * prices[id];
        emit Transfer(msg.sender, address(0), id, amount);
        emit Transfer(address(0), msg.sender, main, amount * prices[id]);
    }

    function buy(uint256 id, uint256 amount) public {
        if (id == main) revert CannotSwapMainForMain();
        balanceOf[msg.sender][id] += amount;
        balanceOf[msg.sender][main] -= amount * prices[id];
        emit Transfer(address(0), msg.sender, id, amount);
        emit Transfer(msg.sender, address(0), main, amount * prices[id]);
    }

    function updateDecimals(uint256 id, uint8 decimals) public {
        permissions[msg.sender].requireSupplyHandler();
        decimals[id] = decimals;
        emit UpdatedDecimals(id, decimals);
    }

    function updateprice(uint256 id, uint256 price) public {
        permissions[msg.sender].requirePriceSetter();
        prices[id] = price;
        emit UpdatedPrice(id, price);
    }

    function setSupplyHandler(address account, bool value) public {
        permissions[msg.sender].requireAdmin();
        permissions[account].setSupplyHandler(value);
    }

    function setPriceSetter(address account, bool value) public {
        permissions[msg.sender].requireAdmin();
        permissions[account].setPriceSetter(value);
    }
}
