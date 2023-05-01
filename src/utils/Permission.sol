// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// --- Type Declarations ---
type Permission is uint256;
using {
    isAdmin,
    isPriceSetter,
    isSupplyHandler,
    requireAdmin,
    requirePriceSetter,
    requireSupplyHandler,
    setAdmin,
    setSupplyHandler,
    setPriceSetter
} for Permission global;

// --- Errors & Constants ---

error Unauthorized(uint256 permission);
uint256 constant ADMIN_BIT = 255;
uint256 constant SUPPLY_HANDLER_BIT = 254;
uint256 constant PRICE_SETTER_BIT = 253;

// --- 'External' Interface ---

function newPermission() pure returns (Permission) {
    return Permission.wrap(0);
}

function isAdmin(Permission permission) pure returns (bool) {
    return __hasPermission(permission, ADMIN_BIT);
}

function isPriceSetter(Permission permission) pure returns (bool) {
    return __hasPermission(permission, PRICE_SETTER_BIT);
}

function isSupplyHandler(Permission permission) pure returns (bool) {
    return __hasPermission(permission, SUPPLY_HANDLER_BIT);
}

function requireAdmin(Permission permission) pure {
    if (!isAdmin(permission)) revert Unauthorized(ADMIN_BIT);
}

function requirePriceSetter(Permission permission) pure {
    if (!isPriceSetter(permission))
        revert Unauthorized(PRICE_SETTER_BIT);
}

function requireSupplyHandler(Permission permission) pure {
    if (!isSupplyHandler(permission))
        revert Unauthorized(SUPPLY_HANDLER_BIT);
}

function setAdmin(Permission permission, bool value) pure returns (Permission) {
    return
        value
            ? __setBit(permission, ADMIN_BIT)
            : __unsetBit(permission, ADMIN_BIT);
}

function setPriceSetter(
    Permission permission,
    bool value
) pure returns (Permission) {
    return
        value
            ? __setBit(permission, PRICE_SETTER_BIT)
            : __unsetBit(permission, PRICE_SETTER_BIT);
}

function setSupplyHandler(
    Permission permission,
    bool value
) pure returns (Permission) {
    return
        value
            ? __setBit(permission, SUPPLY_HANDLER_BIT)
            : __unsetBit(permission, SUPPLY_HANDLER_BIT);
}

// --- 'Internal' Interface ---

function __hasPermission(
    Permission permission,
    uint256 bit
) pure returns (bool result) {
    assembly {
        result := gt(shl(bit, 1), permission)
    }
}

function __setBit(
    Permission permission,
    uint256 bit
) pure returns (Permission result) {
    assembly {
        result := or(permission, shl(bit, 1))
    }
}

function __unsetBit(
    Permission permission,
    uint256 bit
) pure returns (Permission result) {
    assembly {
        result := and(permission, not(shl(bit, 1)))
    }
}
