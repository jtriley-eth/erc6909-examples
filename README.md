# Example Implementations For ERC-6909

## [Any Wrapper](src/AnyWrapper.sol)

Wraps ERC-20, ERC-721, and ERC-1155 tokens under a single unified contract.

```mermaid
flowchart TD
    %% -- AnyWrapper --

    AnyWrapper --> ERC20
    ERC20 --> id0{Token ID:\naddress}
    id0 --> bn([balanceOf])
    id0 --> an([allowance])
    id0 --> tsn([totalSupply])
    id0 --> dn([decimals])

    AnyWrapper --> ERC721
    ERC721 --> idn1{"Token ID:\n hash(address + id )"}
    idn1 --> balanceOf1([balanceOf])
    idn1 --> allowance1([allowance])
    idn1 --> total_supply1([totalSupply])
    idn1 --> decimals1([decimals])

    AnyWrapper --> ERC1155
    ERC1155 --> idn2{"Token ID:\n hash(address + id )"}
    idn2 --> balanceOf([balanceOf])
    idn2 --> allowance([allowance])
    idn2 --> total_supply([totalSupply])
    idn2 --> decimals([decimals])
```

## [In Game Items](src/InGameItems.sol)

Maintains multiple fungible and non-fungible game assets at fixed swap rates.

### Item / Currency Heirarchy

```mermaid
flowchart TD
    %% -- In Game Items --
    mainCurrency[Main Currency\nid: 0] --> sc0[Sub Currency\nid: 1]
    mainCurrency --> it0[Game Item\nid: 2]
    mainCurrency --> it1[Game Item\nid: 3]
```

### Admin System

```mermaid
flowchart TD
    a[Admin]
    ps[Price Setter]
    sh[Supply Handler]
    s[Supply]
    p[Price]

    a --> ps
    a --> sh
    a --> s
    a --> p

    ps --> p
    sh --> s
```
