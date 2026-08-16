/**
 * @fileoverview Rule to require object keys to be sorted
 * @author Toru Nagashima
 */

"use strict";

//------------------------------------------------------------------------------
// Requirements
//------------------------------------------------------------------------------

const astUtils = require("./utils/ast-utils");

//------------------------------------------------------------------------------
// Helpers
//------------------------------------------------------------------------------

/**
 * Gets the property name of the given `Property` node.
 *
 * - If the property's key is an `Identifier` node, this returns the key's name
 *   whether it's a computed property or not.
 * - If the property has a static name, this returns the static name.
 * - Otherwise, this returns null.
 *
 * @param {ASTNode} node - The `Property` node to get.
 * @returns {string|null} The property name or null.
 * @private
 */
function getPropertyName(node) {
    const staticName = astUtils.getStaticPropertyName(node);

    if (staticName !== null) {
        return staticName;
    }

    return node.key.name || null;
}

/**
 * Function to do "natural sort"
 *
 * Origin: <https://github.com/litejs/natural-compare-lite/blob/v1.4.0/index.js>
 *
 * @version    1.4.0
 * @date       2015-10-26
 * @stability  3 - Stable
 * @author     Lauri Rooden (https://github.com/litejs/natural-compare-lite)
 * @license    MIT License
 * @param {string} a - The first character to compare.
 * @param {string} b - The second character to compare.
 * @returns {string} The equality -1 | 0 | 1.
 * @private
 */
function naturalCompare(a, b) {
    let i, codeA,
        codeB = 1,
        posA = 0,
        posB = 0;
    const alphabet = String.alphabet;

    /* eslint-disable no-param-reassign */
    /* eslint-disable no-sequences */

    /**
     * @param {string} str - string.
     * @param {string} pos - position.
     * @param {string} code - character codes.
     * @returns {string} new character codes.
     * @private
     */
    function getCode(str, pos, code) {
        if (code) {
            for (i = pos; code = getCode(str, i), code < 76 && code > 65;) {
                ++i;
            }
            return +str.slice(pos - 1, i);
        }
        code = alphabet && alphabet.indexOf(str.charAt(pos));

        let newCode;

        if (code > -1) {
            newCode = code + 76;
        } else if ((code = str.charCodeAt(pos) || 0), code < 45 || code > 127) {
            newCode = code;
        } else if (code < 46) {
            newCode = 65; // -
        } else if (code < 48) {
            newCode = code - 1;
        } else if (code < 58) {
            newCode = code + 18; // 0-9
        } else if (code < 65) {
            newCode = code - 11;
        } else if (code < 91) {
            newCode = code + 11; // A-Z
        } else if (code < 97) {
            newCode = code - 37;
        } else if (code < 123) {
            newCode = code + 5; // a-z
        } else {
            newCode = code - 63;
        }
        return newCode;
    }

    /* eslint-enable no-sequences */

    if ((a += "") !== (b += "")) {
        for (;codeB;) {
            codeA = getCode(a, posA++);
            codeB = getCode(b, posB++);

            if (codeA < 76 && codeB < 76 && codeA > 66 && codeB > 66) {
                codeA = getCode(a, posA, posA);
                codeB = getCode(b, posB, posA = i);
                posB = i;
            }

            if (codeA !== codeB) {
                return (codeA < codeB) ? -1 : 1;
            }
        }
    }
    return 0;

    /* eslint-enable no-param-reassign */
}


/**
 * Functions which check that the given 2 names are in specific order.
 *
 * Postfix `I` is meant insensitive.
 * Postfix `N` is meant natual.
 *
 * @private
 */
const isValidOrders = {
    asc(a, b) {
        return a <= b;
    },
    ascI(a, b) {
        return a.toLowerCase() <= b.toLowerCase();
    },
    ascN(a, b) {
        return naturalCompare(a, b) <= 0;
    },
    ascIN(a, b) {
        return naturalCompare(a.toLowerCase(), b.toLowerCase()) <= 0;
    },
    desc(a, b) {
        return isValidOrders.asc(b, a);
    },
    descI(a, b) {
        return isValidOrders.ascI(b, a);
    },
    descN(a, b) {
        return isValidOrders.ascN(b, a);
    },
    descIN(a, b) {
        return isValidOrders.ascIN(b, a);
    }
};

//------------------------------------------------------------------------------
// Rule Definition
//------------------------------------------------------------------------------

module.exports = {
    meta: {
        type: "suggestion",

        docs: {
            description: "require object keys to be sorted",
            category: "Stylistic Issues",
            recommended: false,
            url: "https://eslint.org/docs/rules/sort-keys"
        },

        schema: [
            {
                enum: ["asc", "desc"]
            },
            {
                type: "object",
                properties: {
                    caseSensitive: {
                        type: "boolean",
                        default: true
                    },
                    natural: {
                        type: "boolean",
                        default: false
                    },
                    minKeys: {
                        type: "integer",
                        minimum: 2,
                        default: 2
                    }
                },
                additionalProperties: false
            }
        ]
    },

    create(context) {

        // Parse options.
        const order = context.options[0] || "asc";
        const options = context.options[1];
        const insensitive = options && options.caseSensitive === false;
        const natual = options && options.natural;
        const minKeys = options && options.minKeys;
        const isValidOrder = isValidOrders[
            order + (insensitive ? "I" : "") + (natual ? "N" : "")
        ];

        // The stack to save the previous property's name for each object literals.
        let stack = null;

        return {
            ObjectExpression(node) {
                stack = {
                    upper: stack,
                    prevName: null,
                    numKeys: node.properties.length
                };
            },

            "ObjectExpression:exit"() {
                stack = stack.upper;
            },

            SpreadElement(node) {
                if (node.parent.type === "ObjectExpression") {
                    stack.prevName = null;
                }
            },

            Property(node) {
                if (node.parent.type === "ObjectPattern") {
                    return;
                }

                const prevName = stack.prevName;
                const numKeys = stack.numKeys;
                const thisName = getPropertyName(node);

                if (thisName !== null) {
                    stack.prevName = thisName;
                }

                if (prevName === null || thisName === null || numKeys < minKeys) {
                    return;
                }

                if (!isValidOrder(prevName, thisName)) {
                    context.report({
                        node,
                        loc: node.key.loc,
                        message: "Expected object keys to be in {{natual}}{{insensitive}}{{order}}ending order. '{{thisName}}' should be before '{{prevName}}'.",
                        data: {
                            thisName,
                            prevName,
                            order,
                            insensitive: insensitive ? "insensitive " : "",
                            natual: natual ? "natural " : ""
                        }
                    });
                }
            }
        };
    }
};
