const cds = require("@sap/cds");
const { uuid, exists, isdir, mkdirp, read } = cds.utils;

module.exports = cds.service.impl(async function () {

    // Step 1: Declare Employee Service
    const { EmployeeSrv, AddressSrv, ProductService, PurchaseItemSrv, BusinessPartnerSrv, PurchaseOrderSrv } = this.entities;

    // Implementation of an action
    // There are 3 generic handlers:
    // .before() : Pre-check and validation
    // .on()     : Performing DB operation
    // .after()  : Post-processing
    this.before(['UPDATE'], PurchaseItemSrv, async (request, response) => {
        const grossAmount = request.data.GROSS_AMOUNT;
        const currency = request.data.CURRENCY;

        if (currency === 'USD' && grossAmount > 15000) {
            request.error(500, 'Please get in touch with your line manager.');
        }

        if (currency === 'EUR' && grossAmount > 10000) {
            request.error(500, 'Please check with your regional head.');
        }


        this.before(['UPDATE'], AddressSrv, async (request, response) => {
            const country = request.data.COUNTRY;

            if (country !== 'US' && country !== 'GB') {
                request.error(900, 'Please contact your administrator.');
            }
        })


        this.before(['UPDATE'], EmployeeSrv, async (request, response) => {

            const mobileNumber = request.data.phoneNumber;

            if (!mobileNumber.startsWith('+1') &&
                !mobileNumber.startsWith('+44')
            ) {
                request.error(500, 'Unable to update the mobile numbers.');
            }
        })


        this.before(['UPDATE'], BusinessPartnerSrv, async (request, response) => {
            const companyName = request.data.COMPANY_NAME;
            const specialChars = ["[", "'", ",", ".", "-"];

            if (companyName && specialChars.test(companyName)) {
                request.error(500, 'Invalid company name.');
            }
        })


        this.before(['UPDATE'], PurchaseItemSrv, async (request, response) => {
            const position = request.data.PO_ITEM_POS;
            if (
                position !== undefined &&
                position !== null &&
                position % 10 !== 0
            ) {
                request.error(500, 'PO Item position should be a multiple of 10.');
            }
        })

    });

    this.on('createEmployee', async (request, response) => {

        // Step 2: Get the data coming from the API
        const empData = request.data;

        // Step 3: Instantiate the transaction object
        const objTransaction = cds.tx(request);

        // Step 4: Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(EmployeeSrv).entries(empData)
        ]).then((resolve, reject) => {

            if (typeof (resolve) !== undefined) {
                return request.data;
            } else {
                request.error(500, "Error in inserting data into the database")
            }

        }).catch(err => {
            request.error(
                "There is an error:", err.toString())
        });

        // Step 5: Return the data
        return returnData;
    })



    // Implementation of createAddress action
    this.on('createAddress', async (request) => {

        // Step 2: Get the data coming from the API
        const addressData = request.data;

        // Step 3: Instantiate the transaction object
        const objTransaction = cds.tx(request);

        // Step 4: Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(AddressSrv).entries(addressData)
        ])
            .then((resolve) => {

                if (resolve !== undefined) {
                    return request.data;
                } else {
                    request.error(
                        500,
                        "Error in inserting address data into the database"
                    );
                }

            })
            .catch((err) => {

                request.error(
                    500,
                    "There is an error: " + err.toString()
                );

            });

        // Step 5: Return the data
        return returnData;
    });
    this.on('updateAddress', async (request, response) => {
        const {
            NODE_KEY,
            CITY
        } = request.data;
        try {
            const objTransaction = cds.tx(request);

            await objTransaction.update(AddressSrv).with({
                CITY: CITY
            }).where({
                NODE_KEY: NODE_KEY
            })

            return "Successfully updated."
        } catch (error) {
            request.error("Error : ", error)
        }
    })
    // Implementation of createProduct action
    this.on('createProduct', async (request) => {

        // Step 1: Get the data coming from the API
        const productData = request.data;

        // Step 2: Instantiate the transaction object
        const objTransaction = cds.tx(request);

        // Step 3: Insert the product into database
        let returnData = await objTransaction.run([
            INSERT.into(ProductService).entries(productData)
        ])
            .then((resolve) => {

                if (resolve !== undefined) {
                    return request.data;
                } else {
                    request.error(
                        500,
                        "Error in inserting product data into the database"
                    );
                }

            })
            .catch((err) => {

                request.error(
                    500,
                    "There is an error: " + err.toString()
                );

            });

        // Step 4: Return inserted product data
        return returnData;
    });


    // Implementation of updateProduct action
    this.on('updateProduct', async (request, response) => {

        // Step 1: Get NODE_KEY and PRICE from request
        const {
            NODE_KEY,
            PRICE
        } = request.data;

        try {

            // Step 2: Create transaction
            const objTransaction = cds.tx(request);

            // Step 3: Update product price
            await objTransaction
                .update(ProductService)
                .with({
                    PRICE: PRICE
                })
                .where({
                    NODE_KEY: NODE_KEY
                });

            // Step 4: Return message
            return "Successfully updated.";

        } catch (error) {

            request.error(
                500,
                "Error : " + error.toString()
            );

        }
    });

    // Instance Bound Action: Increase selected product price by 10%
    this.on('increasePrice', async (request, response) => {
        try {

            const { NODE_KEY } = request.params[0];

            const transaction = cds.tx(request);

            const product = await transaction.read(ProductService)
                .where({ NODE_KEY });

            if (!product.length) {
                return request.error(404, "Product not found");
            }

            const newPrice = Number(product[0].PRICE) * 1.10;

            await transaction.update(ProductService)
                .with({
                    PRICE: newPrice
                })
                .where({ NODE_KEY });

            const updatedProductPrice = await transaction.read(ProductService)
                .where({ NODE_KEY });

            return updatedProductPrice;

        } catch (error) {
            return "Error : " + error.toString();
        }
    });

    // Instance Bound Function: Get top 20 products sorted by price DESC
    this.on('top20product', async (request, response) => {
        try {


            const transaction = cds.tx(request);

            const products = await transaction.read(ProductService)
                .orderBy('PRICE desc')
                .limit(20);

            return products;

        } catch (error) {
            return request.error(500, "Error : " + error.toString());
        }
    });


    this.on('deleteAddress', async (request, response) => {
        const {
            NODE_KEY,
            CITY
        } = request.data;
        try {
            const objTransaction = cds.tx(request);

            await objTransaction.delete(AddressSrv).where({
                NODE_KEY: NODE_KEY
            })

            return "Successfully deleted."
        } catch (error) {
            request.error("Error : ", error)
        }
    })


    // Implementation of custom function
    // Implementation of custom function

    this.on('getHighestSalariedEmployees', async (request, response) => {

        try {

            // Step - 1 : Create an object for the transaction

            const transaction = cds.tx(request);


            // Step - 2 : Get salaries of an employee using Transaction object

            const response = await transaction.read(EmployeeSrv).orderBy({

                salaryAmount: 'desc'

            }).limit(10);


            // Step - 3 : Display the employee salaries

            return response;


        } catch (error) {

            request.error("Error : ", error);

        }

    })

    this.on('discountPrice', async (request, response) => {
        try {
            //Step-1 : Get the parameter from the entity
            const ID = request.param[0];

            //Step-2 : Creating object for transaction service using request
            const transaction = cds.tx(request);
            //Step-3 : Update the purchase order service
            await transaction.update(PurchaseOrderSrv).with({
                GROSS_AMOUNT: {
                    '-=': 1000
                },
                NET_AMOUNT: {
                    '-=': 800
                },
                TAX_AMOUNT: {
                    '-=': 200
                }
            }).where(ID)

            const updatePOInfo = await transaction.read(PurchaseOrderSrv);
        } catch (error) {
            return " Error : " + error.toString();
        }
    })
    this.on('largestOrder', async (request, response) => {
        try {

            const transaction = cds.tx(request);

            const reply = await transaction.read(PurchaseOrderSrv).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(5);

            return reply;

        } catch (error) {
            return "Error : " + error.toString();
        }
    })

    // Implementation of custom function

    this.on('getHeighestPricedProduct', async (request, response) => {
        try {
            // Step - 1 : Create an object for the transaction
            const transaction = cds.tx(request);
            // Step - 2 : Get highest priced product
            const response = await transaction.read(ProductService).orderBy({
                PRICE: 'desc'
            }).limit(1);
            // Step - 3 : Display the highest priced product
            return response;
        } catch (error) {
            request.error("Error : ", error);
        }
    })


    //Bounded action and function

    this.on('increaseSalary', EmployeeSrv, async (req) => {
        try {
            const ID = req.params[0].ID;
            const employee = await SELECT.one
                .from(EmployeeSrv)
                .where({ ID });
            if (!employee) {
                return req.error(404, 'Employee not found');
            }
            const oldSalary = Number(employee.salaryAmount);
            const newSalary = oldSalary * 1.15;
            await UPDATE(EmployeeSrv)
                .set({
                    salaryAmount: newSalary
                })
                .where({ ID });
            return newSalary;
        } catch (error) {
            return req.error(500, error.message);
        }
    });


    this.on('top20HighestPaid', EmployeeSrv, async (req) => {
        try {
            const result = await SELECT
                .from(EmployeeSrv)
                .orderBy('salaryAmount desc')
                .limit(20);
            return result;
        } catch (error) {
            return req.error(500, error.message);
        }

    })

    this.on('getUtilities', async (request, response) => {

        let vUUID = uuid(),
            vPackageContent = null,
            vInput = "%E0%A4%A",
            uri,
            dirExists = false,
            isFileExists = false;

        // Check if file exists
        if (exists('srv/request.http')) {
            isFileExists = true;
        }

        // Check if directory exists
        if (isdir('app')) {
            dirExists = true;
        }

        // Decode URI
        try {
            uri = decodeURI(vInput);

            // Make Directory
            await mkdir('srv/lib');

        } catch {
            uri = vInput;
        }

        // Read package.json
        vPackageContent = await read('package.json');

        // Final Value
        var finalValue = {
            uuid: vUUID,
            uri: uri,
            isFileExists: isFileExists,
            dirExists: dirExists,
            packageInfo: vPackageContent
        };

        return finalValue;
    });
});