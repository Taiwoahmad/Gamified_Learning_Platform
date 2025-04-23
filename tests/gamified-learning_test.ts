import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.2/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that user can register, earn points, and redeem them",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;
        
        // Register user
        let block = chain.mineBlock([
            Tx.contractCall('gamified_learning', 'register-user', [], user1.address)
        ]);
        block.receipts[0].result.expectOk().expectBool(true);
        
        // Check user points (should be 0)
        let userPoints = chain.callReadOnlyFn(
            'gamified_learning',
            'get-user-points',
            [types.principal(user1.address)],
            deployer.address
        );
        userPoints.result.expectOk().expectUint(0);
        
        // Earn points
        block = chain.mineBlock([
            Tx.contractCall('gamified_learning', 'earn-points', [types.uint(500)], user1.address)
        ]);
        block.receipts[0].result.expectOk().expectUint(500);
        
        // Check user points (should be 500)
        userPoints = chain.callReadOnlyFn(
            'gamified_learning',
            'get-user-points',
            [types.principal(user1.address)],
            deployer.address
        );
        userPoints.result.expectOk().expectUint(500);
        
        // Get conversion rate
        const conversionRate = chain.callReadOnlyFn(
            'gamified_learning',
            'get-conversion-rate',
            [],
            deployer.address
        );
        conversionRate.result.expectOk().expectUint(100);
        
        // Redeem points
        block = chain.mineBlock([
            Tx.contractCall('gamified_learning', 'redeem-points', [], user1.address)
        ]);
        block.receipts[0].result.expectOk().expectBool(true);
        
        // Check user points after redemption (should be 0)
        userPoints = chain.callReadOnlyFn(
            'gamified_learning',
            'get-user-points',
            [types.principal(user1.address)],
            deployer.address
        );
        userPoints.result.expectOk().expectUint(0);
        
        // Check user redeemed points
        const redeemedPoints = chain.callReadOnlyFn(
            'gamified_learning',
            'get-user-redeemed',
            [types.principal(user1.address)],
            deployer.address
        );
        redeemedPoints.result.expectOk().expectUint(500);
    },
});

Clarinet.test({
    name: "Ensure that admin can change conversion rate",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const user1 = accounts.get('wallet_1')!;
        
        // Get initial conversion rate
        let conversionRate = chain.callReadOnlyFn(
            'gamified_learning',
            'get-conversion-rate',
            [],
            deployer.address
        );
        conversionRate.result.expectOk().expectUint(100);
        
        // Change conversion rate (only deployer/admin can do this)
        let block = chain.mineBlock([
            Tx.contractCall('gamified_learning', 'set-conversion-rate', [types.uint(200)], deployer.address)
        ]);
        block.receipts[0].result.expectOk().expectUint(200);
        
        // Get new conversion rate
        conversionRate = chain.callReadOnlyFn(
            'gamified_learning',
            'get-conversion-rate',
            [],
            deployer.address
        );
        conversionRate.result.expectOk().expectUint(200);
        
        // Non-admin should not be able to change conversion rate
        block = chain.mineBlock([
            Tx.contractCall('gamified_learning', 'set-conversion-rate', [types.uint(300)], user1.address)
        ]);
        block.receipts[0].result.expectErr().expectUint(103);
    },
});
