import { Controller } from "@hotwired/stimulus"

import { SVG } from "@svgdotjs/svg.js"

export default class extends Controller {
    static values = { rounds: Object }

    // height of round
    roundHeight = 100;
    // width of round
    roundWidth = 100;

    // vertical padding between rounds
    heightPadding = 20;
    // horizontal padding between rounds
    widthPadding = 40;

    // width of marker
    markerWidth = 4;
    // height of marker
    markerHeight = 4;

    // how much to lower each successive level
    levelLowerAmount = 50;

    connect() {
        console.log("Hello!");
        this.draw(this.roundsValue);
    }

    // rounds: Object
    draw(rounds) {
        // key: int value: SVG rect
        let roundPositionToSVG = {};

        // key: int value: int describing the level (0, 1, or 2)
        let roundPositionToLevel = {};
        this.initializeRoundPositionToLevel(rounds, roundPositionToLevel);

        var draw = SVG().addTo(this.element).size(3 * (this.roundWidth + this.widthPadding), 3 * (this.roundHeight + this.heightPadding + this.levelLowerAmount));

        var marker = draw.marker(this.markerWidth, this.markerHeight, (add) => {
            add.polygon([
                [0, 0],
                [this.markerWidth, this.markerHeight / 2],
                [0, this.markerHeight]
            ])
        }).ref(0, this.markerHeight / 2);

        var startingContainer = draw.nested().move(0,0);
        var intermediateContainer = draw.nested().move(this.roundWidth + this.widthPadding, this.levelLowerAmount);
        var finalContainer = draw.nested().move(2 * (this.roundWidth + this.widthPadding), this.levelLowerAmount * 2);

        this.drawLevel(startingContainer, rounds.starting_rounds, roundPositionToSVG);
        this.drawLevel(intermediateContainer, rounds.intermediate_rounds, roundPositionToSVG);
        this.drawLevel(finalContainer, [rounds.final_round], roundPositionToSVG);

        for (var r of rounds.starting_rounds) {
            this.drawNextRoundArrows(draw, marker, r, roundPositionToLevel, roundPositionToSVG);
        }
        for (var r of rounds.intermediate_rounds) {
            this.drawNextRoundArrows(draw, marker, r, roundPositionToLevel, roundPositionToSVG);
        }   
    }

    // rounds: Object
    // roundPositionToLevel: an empty hash
    initializeRoundPositionToLevel(rounds, roundPositionToLevel) {
        for (var round of rounds.starting_rounds) {
            roundPositionToLevel[round.index] = 0;
        }
        for (var round of rounds.intermediate_rounds) {
            roundPositionToLevel[round.index] = 1;
        }
        roundPositionToLevel[rounds.final_round.index] = 2;
    }
    
    // container: SVG container, rounds: array of objects, roundPositionToSVG: hash 
    drawLevel(container, rounds, roundPositionToSVG) {
        var dy = 0;
        for (var r of rounds) {
            var rect = container.rect(this.roundHeight, this.roundWidth).move(0, dy).attr({ fill: '#f06' });
            var playersContainer = container.nested().move(0, dy);
            this.drawPlayers(playersContainer, r.players);
    
            roundPositionToSVG[r.index] = rect;
            dy += this.roundHeight + this.heightPadding
        }
    }
    
    // container: SVG container
    // Players: array of names
    drawPlayers(container, players) {
        var dy = 0;
        for (var p of players) {
            container.text(p.name).move(0,dy).font({ fill: '#000' });
            dy += 20;
        }
    }
    
    // draw: SVG object, marker: SVG marker, round: object, roundPositionToLevel: object
    drawNextRoundArrows(draw, marker, round, roundPositionToLevel, roundPositionToSVG) {
        var sourceLevel = roundPositionToLevel[round.index];
        var sourceRect = roundPositionToSVG[round.index];
        var sourceBBox = sourceRect.rbox(draw);
    
        for (var destinationIndex of round.next_round_positions) {
            var destinationRect = roundPositionToSVG[destinationIndex];
            var destinationLevel = roundPositionToLevel[destinationIndex];
            var destBBox = destinationRect.rbox(draw);
    
            // If directly adjacent, draw an arrow from middle
            if (destinationLevel - sourceLevel == 1) {
                draw.line(
                        sourceBBox.x + sourceRect.width(), 
                        sourceBBox.y + (sourceRect.height() / 2),
                        destBBox.x - this.markerWidth * 4,
                        sourceBBox.y + (sourceRect.height() / 2))
                    .stroke({ color: 'black', width: 4})
                    .marker('end', marker);
            } else if (destinationLevel - sourceLevel > 1) {
                // else, draw an arrow from the top
                draw.polyline(
                    [
                        [sourceBBox.x + sourceBBox.width, sourceBBox.y + 4],
                        [destBBox.x + (destBBox.width / 2), sourceBBox.y + 4],
                        [destBBox.x + (destBBox.width / 2), destBBox.y - this.markerWidth * 4]
                    ])
                    .fill('none')
                    .stroke({ color: 'black', width: 4 })
                    .marker('end', marker);
            } else {
                console.log("something went wrong");
            }
        }
    }
}