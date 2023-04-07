// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../DoACollection.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite is DoACollection {

    DoACollection public doaCollection;
    address minterAdr;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        doaCollection = new DoACollection();
        minterAdr = TestsAccounts.getAccount(0);
    }

    function checkSafeMint() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        doaCollection.safeMint(minterAdr);
        Assert.equal(doaCollection.totalSupply(), 1, 'Should be 1');

        doaCollection.safeBatchMint(minterAdr, 5);
        Assert.equal(doaCollection.totalSupply(), 6, 'Should be 6');

        try
            doaCollection.safeMint(minterAdr, 3)  {

            Assert.ok(false, '3 already minted');
        } catch Error(string memory) {
            Assert.ok(true, 'should fail for 3');
        } catch (bytes memory) {
            Assert.ok(false, 'failed unexpected');
        }

        doaCollection.safeMint(minterAdr, 8);
        Assert.equal(doaCollection.totalSupply(), 7, 'Should be 7');
    }

    
}
    