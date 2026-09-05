import SwiftUI

// MARK: - BadgeFlowLayout
struct BadgeFlowLayout: Layout {
    struct LayoutResult {
        var size: CGSize
        var positions: [Int: CGPoint]
    }
    
    private func calculateLayout(proposal: ProposedViewSize, subviews: Subviews) -> LayoutResult {
        let containerWidth = proposal.width ?? .infinity
        var currentX: CGFloat = .zero
        var currentY: CGFloat = .zero
        var lineHeight: CGFloat = .zero
        var maxX: CGFloat = .zero
        
        var positions: [Int: CGPoint] = [:]
        var unplacedIds = Array(subviews.indices)
        let sizes = unplacedIds.map { subviews[$0].sizeThatFits(.unspecified) }
        
        while !unplacedIds.isEmpty {
            let freeSpace = containerWidth - currentX
            
            if let matchIndex = unplacedIds.firstIndex(where: {
                sizes[$0].width <= freeSpace || currentX == .zero
            }) {
                let originalIndex = unplacedIds[matchIndex]
                let size = sizes[originalIndex]
                
                positions[originalIndex] = CGPoint(x: currentX, y: currentY)
                
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + Constants.badgesSpacing
                maxX = max(maxX, currentX)

                unplacedIds.remove(at: matchIndex)
            } else {
                currentX = .zero
                currentY += lineHeight + Constants.badgesSpacing
                lineHeight = .zero
            }
        }
        
        let totalHeight = currentY + lineHeight
        let totalWidth = containerWidth == .infinity ? maxX : containerWidth
        
        return LayoutResult(
            size: CGSize(width: totalWidth, height: totalHeight),
            positions: positions
        )
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        calculateLayout(proposal: proposal, subviews: subviews).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let layoutProposal = ProposedViewSize(width: bounds.width, height: bounds.height)
        let result = calculateLayout(proposal: layoutProposal, subviews: subviews)
        
        for index in subviews.indices {
            if let position = result.positions[index] {
                let finalPoint = CGPoint(x: position.x + bounds.minX, y: position.y + bounds.minY)
                subviews[index].place(at: finalPoint, proposal: .unspecified)
            }
        }
    }
}

// MARK: - Constants
private extension BadgeFlowLayout {
    enum Constants {
        static var badgesSpacing: CGFloat = 8
    }
}
